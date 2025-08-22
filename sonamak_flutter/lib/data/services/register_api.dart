
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class RegisterApi {
  /// React: register (multipart) -> POST /register
  static Future<Response<dynamic>> register(FormData form) {
    return HttpClient.I.post('/register', data: form, options: Options(headers: {'Content-Type': 'multipart/form-data'}));
  }

  /// React: choosePlan -> POST /register/choose-plan
  static Future<Response<Map<String, dynamic>>> choosePlan(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/register/choose-plan', data: data);
  }
}
