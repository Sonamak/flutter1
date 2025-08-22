import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

/// Exponential backoff + jitter for retryable requests.
/// Retries:
///  - Network errors (no response)
///  - 429, 503
///  - 5xx for idempotent methods (GET/HEAD) or when X-Idempotency-Key is present
class RetryInterceptor extends Interceptor {
  RetryInterceptor({required this.dio, this.maxRetries = 3, this.baseDelay = const Duration(milliseconds: 300)});
  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  bool _isIdempotent(RequestOptions o) {
    final m = (o.method.toUpperCase());
    if (m == 'GET' || m == 'HEAD') return true;
    // Treat as idempotent if client provided idempotency key
    if ((o.headers['X-Idempotency-Key'] ?? o.headers['x-idempotency-key']) != null) return true;
    return false;
  }

  bool _isRetryableResponse(Response r) {
    final code = r.statusCode ?? 0;
    if (code == 429 || code == 503) return true;
    if (code >= 500 && _isIdempotent(r.requestOptions)) return true;
    return false;
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout;
  }

  Future<void> _sleep(int attempt) async {
    // Full jitter: random between 0 and base * 2^attempt
    final ms = baseDelay.inMilliseconds * pow(2, attempt);
    final jitter = Random().nextDouble();
    final waitMs = (jitter * ms).clamp(50, 8000).toInt();
    await Future.delayed(Duration(milliseconds: waitMs));
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    final attempt = (req.extra['retry_attempt'] as int?) ?? 0;

    if (attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    if (_isNetworkError(err)) {
      await _sleep(attempt);
      try {
        final res = await dio.fetch(_cloneOptions(req, attempt + 1));
        handler.resolve(res);
        return;
      } catch (_) { /* fallthrough */ }
    }

    final res = err.response;
    if (res != null && _isRetryableResponse(res)) {
      await _sleep(attempt);
      try {
        final response = await dio.fetch(_cloneOptions(req, attempt + 1));
        handler.resolve(response);
        return;
      } catch (_) { /* fallthrough */ }
    }

    handler.next(err);
  }

  RequestOptions _cloneOptions(RequestOptions req, int attempt) {
    return RequestOptions(
      path: req.path,
      method: req.method,
      baseUrl: req.baseUrl,
      queryParameters: Map<String, dynamic>.from(req.queryParameters),
      data: req.data,
      headers: Map<String, dynamic>.from(req.headers),
      responseType: req.responseType,
      sendTimeout: req.sendTimeout,
      receiveTimeout: req.receiveTimeout,
      contentType: req.contentType,
      followRedirects: req.followRedirects,
      extra: Map<String, dynamic>.from(req.extra)..['retry_attempt'] = attempt,
      cancelToken: req.cancelToken,
    );
  }
}
