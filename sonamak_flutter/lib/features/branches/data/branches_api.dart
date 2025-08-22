
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class BranchesApi {
  static Future<Response<List<dynamic>>> getBranches() =>
      HttpClient.I.get<List<dynamic>>('/branches/all-branches');

  static Future<Response<Map<String, dynamic>>> branchUpdate(Map<String, dynamic> data) =>
      HttpClient.I.post<Map<String, dynamic>>('/branches/update', data: data);

  static Future<Response<Map<String, dynamic>>> deleteBranch(int id) =>
      HttpClient.I.post<Map<String, dynamic>>('/branches/delete/$id');
}
