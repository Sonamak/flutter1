import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class AuthApi {
  static Future<Response<Map<String, dynamic>>> loginPhone({
    required String phone,
    required String countryCode,
    required String password,
    bool rememberMe = false,
  }) {
    final ccDigits = countryCode.replaceAll(RegExp(r'[^0-9]'), '');
    return HttpClient.I.post<Map<String, dynamic>>('/login', data: {
      'phone': phone,
      'country_code': ccDigits,
      'password': password,
      'remember_me': rememberMe ? 1 : 0,
    });
  }

  static Future<Response<Map<String, dynamic>>> me() {
    return HttpClient.I.get<Map<String, dynamic>>('/me');
  }

  static Future<Response<Map<String, dynamic>>> logout() {
    return HttpClient.I.post<Map<String, dynamic>>('/logout');
  }
}
