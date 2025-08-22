import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/idempotency_key.dart';

/// Adds `X-Idempotency-Key` header to POST/PUT requests if not present.
/// If options.extra['idempotencyKey'] exists, uses that for stability across retries.
class IdempotencyInterceptor extends Interceptor {
  static const header = 'X-Idempotency-Key';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final m = options.method.toUpperCase();
    if (m == 'POST' || m == 'PUT' || m == 'PATCH') {
      final existing = options.headers[header] ?? options.headers[header.toLowerCase()];
      if (existing == null) {
        final k = (options.extra['idempotencyKey'] as String?) ?? IdempotencyKey.generate();
        options.headers[header] = k;
      }
    }
    handler.next(options);
  }
}
