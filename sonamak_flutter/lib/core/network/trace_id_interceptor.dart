import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/idempotency_key.dart';

/// TraceIdInterceptor — inject X-Trace-Id for request correlation in logs.
class TraceIdInterceptor extends Interceptor {
  static const header = 'X-Trace-Id';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent(header, () => IdempotencyKey.generate(prefix: 'trace'));
    handler.next(options);
  }
}
