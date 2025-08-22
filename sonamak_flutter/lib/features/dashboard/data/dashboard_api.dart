import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class DashboardApi {
  static Future<Response<List<dynamic>>> queue({int? branchId}) {
    return HttpClient.I.get<List<dynamic>>(
      '/dashboard/queue',
      queryParameters: branchId != null ? {'branch_id': branchId} : null,
    );
  }

  static Future<Response<dynamic>> queueUpdate(Map<String, dynamic> body) {
    return HttpClient.I.post('/dashboard/queue/update', data: body);
  }

  static Future<Response<dynamic>> queueManual(Map<String, dynamic> body) {
    return HttpClient.I.post('/dashboard/queue/manual', data: body);
  }

  static Future<Response<dynamic>> queueLine(Map<String, dynamic> body) {
    return HttpClient.I.post('/dashboard/queue/line', data: body);
  }

  static Future<Response<dynamic>> paymentClear(Map<String, dynamic> body) {
    return HttpClient.I.post('/dashboard/payment-clear', data: body);
  }

  static Future<Response<List<dynamic>>> payments({int? branchId, String? date}) {
    final qp = <String, dynamic>{};
    if (branchId != null) qp['branch_id'] = branchId;
    if (date != null) qp['date'] = date;
    return HttpClient.I.get<List<dynamic>>('/dashboard/payments', queryParameters: qp.isEmpty ? null : qp);
  }
}
