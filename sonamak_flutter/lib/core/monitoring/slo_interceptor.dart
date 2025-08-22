import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/monitoring/slo_monitor.dart';

/// SLOInterceptor — measures request durations and errors into a shared SLOMonitor.
class SLOInterceptor extends Interceptor {
  final SLOMonitor monitor;
  SLOInterceptor(this.monitor);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['__slo_start_ms'] = DateTime.now().millisecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _record(response.requestOptions, response.statusCode ?? 0);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _record(err.requestOptions, err.response?.statusCode ?? 0, error: true);
    handler.next(err);
  }

  void _record(RequestOptions ro, int status, {bool error = false}) {
    final start = ro.extra['__slo_start_ms'] as int?;
    final dur = start != null ? (DateTime.now().millisecondsSinceEpoch - start) : 0;
    final success = !error && status >= 200 && status < 400;
    monitor.record(durationMs: dur, success: success);
  }
}
