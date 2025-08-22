import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/core/network/interceptors.dart' show NetKeys;

/// Intercepts 401/419 responses, clears the auth token, and routes to /login.
/// Keeps behavior consistent across desktop & mobile.
class SessionInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final code = response.statusCode ?? 0;
    if (code == 401 || code == 419) {
      await _logoutSideEffects();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final code = err.response?.statusCode ?? 0;
    if (code == 401 || code == 419) {
      await _logoutSideEffects();
    }
    handler.next(err);
  }

  Future<void> _logoutSideEffects() async {
    await SecureStorage.delete(NetKeys.authTokenStorageKey);
    // Try to navigate to login; ignore if nav tree not built yet.
    RouteHub.navKey.currentState?.pushNamedAndRemoveUntil('/login', (r) => false);
  }
}
