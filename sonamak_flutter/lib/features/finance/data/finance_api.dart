
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class FinanceApi {
  static Future<Response<List<dynamic>>> getTransactionBranches() {
    return HttpClient.I.get<List<dynamic>>('/financial_transaction/branches');
  }

  static Future<Response<List<dynamic>>> getTransactions() {
    return HttpClient.I.get<List<dynamic>>('/financial_transaction/all-data');
  }

  static Future<Response<List<dynamic>>> searchTransactions({
    String? event,
    String? date,
    String? filter,
    int? branchId,
    int? isVisa,
    int? visit,
    dynamic pdf,
  }) {
    final params = <String, dynamic>{
      if (event != null) 'event': event,
      if (date != null) 'date': date,
      if (filter != null) 'filter': filter,
      if (branchId != null) 'branchId': branchId,
      if (pdf != null) 'pdf': pdf,
      if (isVisa != null) 'is_visa': isVisa,
      if (visit != null) 'visit': visit,
    };
    return HttpClient.I.get<List<dynamic>>('/financial_transaction/filter', queryParameters: params);
  }

  static Future<Response<Map<String, dynamic>>> saveCustody({required num custody, required int branchId}) {
    final data = {'custody': custody, 'branchId': branchId};
    return HttpClient.I.post<Map<String, dynamic>>('/financial_transaction/custody', data: data);
  }

  static Future<Response<dynamic>> transactionExcelDownload(Map<String, dynamic>? params) {
    return HttpClient.I.get<dynamic>('/financial_transaction/excel-download', queryParameters: params);
  }

  static Future<Response<Map<String, dynamic>>> financialPdf({
    String? event,
    String? date,
    String? filter,
    int? branchId,
    int? isVisa,
    int? type,
  }) {
    final params = <String, dynamic>{
      if (event != null) 'event': event,
      if (date != null) 'date': date,
      if (filter != null) 'filter': filter,
      if (branchId != null) 'branchId': branchId,
      if (isVisa != null) 'is_visa': isVisa,
      if (type != null) 'type': type,
    };
    return HttpClient.I.get<Map<String, dynamic>>('/financial_transaction/financial-pdf', queryParameters: params);
  }

  static Future<Response<Map<String, dynamic>>> dashboard() {
    return HttpClient.I.get<Map<String, dynamic>>('/dashboard');
  }

  static Future<Response<Map<String, dynamic>>> getPaymentSlip({required int userId, required int page, Map<String, dynamic>? filter}) {
    final params = <String, dynamic>{'page': page, if (filter != null) ...filter};
    return HttpClient.I.get<Map<String, dynamic>>('/users/slip/$userId', queryParameters: params);
  }

  static Future<Response<Map<String, dynamic>>> searchSlip({
    required int userId,
    required int page,
    String? event,
    String? date,
    dynamic filter,
    int? branchId,
  }) {
    final params = <String, dynamic>{
      'page': page,
      if (event != null) 'event': event,
      if (date != null) 'date': date,
      if (filter != null) 'filter': filter,
      if (branchId != null) 'branchId': branchId,
    };
    return HttpClient.I.get<Map<String, dynamic>>('/users/slipScoop/$userId', queryParameters: params);
  }
}
