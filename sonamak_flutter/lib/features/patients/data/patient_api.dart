
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class PatientApi {
  /// Fetch one page of patients; server may accept different param names.
  static Future<Response<List<dynamic>>> listPage({
    int? branchId,
    String? q,
    int page = 1,
    int perPage = 200,
  }) {
    final qp = <String, dynamic>{};
    if (branchId != null) {
      // send both underscore and camel to be compatible
      qp['branch_id'] = branchId;
      qp['branchId'] = branchId;
    }
    if (q != null && q.isNotEmpty) qp['q'] = q;
    qp['page'] = page;
    // send multiple common keys for page size
    qp['per_page'] = perPage;
    qp['perPage'] = perPage;
    qp['limit'] = perPage;
    return HttpClient.I.get<List<dynamic>>('/patients/filter', queryParameters: qp);
  }

  /// Backwards-compat wrappers (single page)
  static Future<Response<List<dynamic>>> listAll({int? branchId, String? q}) =>
      listPage(branchId: branchId, q: q);

  static Future<Response<Map<String, dynamic>>> getProfile(int id) {
    return HttpClient.I.get<Map<String, dynamic>>('/patients/profile', queryParameters: {'id': id});
  }

  static Future<Response<dynamic>> update(Map<String, dynamic> data) =>
      HttpClient.I.post('/patients/update', data: data);

  static Future<Response<dynamic>> create(Map<String, dynamic> data) =>
      HttpClient.I.post('/patients/create', data: data);

  static Future<Response<dynamic>> remove(int id) =>
      HttpClient.I.post('/patients/delete/$id');

  static Future<Response<List<dynamic>>> examinations(int patientId) =>
      HttpClient.I.get<List<dynamic>>('/patients/history', queryParameters: {'patient': patientId});
}
