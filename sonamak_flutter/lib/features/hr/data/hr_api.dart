
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class HrApi {
  static Future<Response<dynamic>> permission(int role) =>
      HttpClient.I.get('/settings/permission', queryParameters: {'role': role});
  static Future<Response<dynamic>> roleCreate(String name) =>
      HttpClient.I.post('/settings/role/create', data: {'role': name});
  static Future<Response<dynamic>> roleUpdate(int roleId, List<int> permissions) =>
      HttpClient.I.post('/settings/role/update', data: {'role': roleId, 'permissions': permissions});

  static Future<Response<List<dynamic>>> appointments(Map<String, dynamic> query) =>
      HttpClient.I.get<List<dynamic>>('/schedules/appointments', queryParameters: query);
  static Future<Response<dynamic>> confirmSchedule(Map<String, dynamic> data) =>
      HttpClient.I.post('/schedules/confirm', data: data);
  static Future<Response<dynamic>> schedulesExcel(Map<String, dynamic> query) =>
      HttpClient.I.get('/schedules/excel-download', queryParameters: query);

  static Future<Response<List<dynamic>>> users() => HttpClient.I.get<List<dynamic>>('/users/all-users');
  static Future<Response<Map<String, dynamic>>> userData(int id) =>
      HttpClient.I.get<Map<String, dynamic>>('/users/user-data', queryParameters: {'id': id});
  static Future<Response<dynamic>> updateUser(Map<String, dynamic> data) => HttpClient.I.post('/users/update', data: data);
  static Future<Response<dynamic>> deleteUser(int id) => HttpClient.I.post('/users/delete/%24{id}'.replaceAll('%24','\$'));
  static Future<Response<dynamic>> resetUserPassword(int id) => HttpClient.I.post('/users/reset-password', data: {'id': id});
  static Future<Response<dynamic>> usersExcel(Map<String, dynamic> query) =>
      HttpClient.I.get('/users/excel-download', queryParameters: query);

  static Future<Response<List<dynamic>>> usersWorkBranch(int branchId) =>
      HttpClient.I.get<List<dynamic>>('/users/work-branch', queryParameters: {'branch': branchId});

  static Future<Response<List<dynamic>>> usersProceduresPercentage(int branchId) =>
      HttpClient.I.get<List<dynamic>>('/users/procedures-percentage', queryParameters: {'branch': branchId});
}
