
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class MembersApi {
  static Future<Response<List<dynamic>>> listUsers() => HttpClient.I.get<List<dynamic>>('/users/all-users');
  static Future<Response<Map<String, dynamic>>> getUser(int id) => HttpClient.I.get<Map<String, dynamic>>('/users/user-data', queryParameters: {'id': id});
  static Future<Response<dynamic>> updateUser(Map<String, dynamic> data) => HttpClient.I.post('/users/update', data: data);
  static Future<Response<dynamic>> removeUser(int id) => HttpClient.I.post('/users/delete/%24{id}'.replaceAll('%24','\$'));
  static Future<Response<List<dynamic>>> proceduresPercentage(int memberId) => HttpClient.I.get<List<dynamic>>('/users/procedures-percentage', queryParameters: {'user': memberId});
}
