import 'dart:io' show Platform;
import 'package:dio/dio.dart';

class VersionHeaderInterceptor extends Interceptor {
  VersionHeaderInterceptor({required this.version});
  final String version;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Client-Version'] = version;
    options.headers['X-Client-Platform'] = Platform.operatingSystem;
    handler.next(options);
  }
}
