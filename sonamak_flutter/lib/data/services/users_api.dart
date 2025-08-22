
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class UsersApi {
  /// React: forgetResetPassword -> POST /reset-password
  static Future<Response<Map<String, dynamic>>> forgetResetPassword(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/reset-password', data: data);
  }

  /// React: resetPassword -> POST /users/reset-password
  static Future<Response<Map<String, dynamic>>> resetPassword(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/users/reset-password', data: data);
  }
}
