import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/realtime/realtime_client.dart';

/// Adds 'X-Socket-Id' header when available so the backend can ignore self-originated events.
class SocketIdInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final id = Realtime.I.socketId;
    if (id != null && id.isNotEmpty) {
      options.headers['X-Socket-Id'] = id;
    }
    handler.next(options);
  }
}
