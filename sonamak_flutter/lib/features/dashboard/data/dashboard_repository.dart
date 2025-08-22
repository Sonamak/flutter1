import 'package:dio/dio.dart';
import 'package:sonamak_flutter/features/dashboard/data/dashboard_api.dart';

class DashboardRepository {
  const DashboardRepository();

  Future<List<Map<String, dynamic>>> getQueue({int? branchId}) async {
    final Response<List<dynamic>> res = await DashboardApi.queue(branchId: branchId);
    final list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map((e) => e.cast<String, dynamic>()).toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> getPayments({int? branchId, String? date}) async {
    final Response<List<dynamic>> res = await DashboardApi.payments(branchId: branchId, date: date);
    final list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map((e) => e.cast<String, dynamic>()).toList(growable: false);
  }

  Future<void> updateQueue(Map<String, dynamic> body) async {
    await DashboardApi.queueUpdate(body);
  }

  Future<void> manualQueue(Map<String, dynamic> body) async {
    await DashboardApi.queueManual(body);
  }

  Future<void> moveLine(Map<String, dynamic> body) async {
    await DashboardApi.queueLine(body);
  }

  Future<void> clearPayment(Map<String, dynamic> body) async {
    await DashboardApi.paymentClear(body);
  }
}
