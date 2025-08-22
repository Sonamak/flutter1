import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/uat/uat_flags.dart';

class UatSessionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (UatFlags.enabled.value && (UatFlags.sessionId.value ?? '').isNotEmpty) {
      options.headers['X-UAT-Session'] = UatFlags.sessionId.value;
    } else {
      options.headers.remove('X-UAT-Session');
    }
    handler.next(options);
  }
}
