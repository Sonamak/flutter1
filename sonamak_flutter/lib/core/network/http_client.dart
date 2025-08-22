import 'package:dio/dio.dart';
import 'package:sonamak_flutter/data/services/api_config.dart';
import 'package:sonamak_flutter/core/network/interceptors.dart';
import 'package:sonamak_flutter/core/network/session_interceptor.dart';

class HttpClient {
  HttpClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      headers: {'Accept': 'application/json'},
      validateStatus: (code) => code != null && code >= 200 && code < 600,
    ),
  );

  static bool _initialized = false;

  static Dio get instance {
    if (!_initialized) {
      _dio.interceptors.addAll([
        AuthInterceptor(),
        LocaleInterceptor(),
        OriginInterceptor(),
        // Transport parity (Phase 4): JSON/multipart AES + response decrypt + payload unwrap.
        SonamakCipherInterceptor(),
        // Session lifecycle (Phase 5): purge token & route to /login on 401/419.
        SessionInterceptor(),
      ]);
      _initialized = true;
    }
    return _dio;
  }

  static Dio get I => instance;

  static void rebase(String newBaseUrl) {
    if (newBaseUrl.isEmpty) return;
    _dio.options.baseUrl = newBaseUrl;
  }
}
