
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class PurchasesApi {
  /// GET /financial_transaction/all-purchases
  static Future<Response<List<dynamic>>> getPurchases() {
    return HttpClient.I.get<List<dynamic>>('/financial_transaction/all-purchases');
  }

  /// GET /financial_transaction/purchases/filter
  static Future<Response<List<dynamic>>> searchPurchases({
    String? event,
    String? filter,
    int? branchId,
    String? date,
    int? type,
  }) {
    final params = <String, dynamic>{
      if (event != null) 'event': event,
      if (filter != null) 'filter': filter,
      if (branchId != null) 'branch_id': branchId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
    };
    return HttpClient.I.get<List<dynamic>>('/financial_transaction/purchases/filter', queryParameters: params);
  }

  /// GET /purchases
  static Future<Response<List<dynamic>>> getPurchasesData() {
    return HttpClient.I.get<List<dynamic>>('/purchases');
  }

  /// POST /purchases/insert
  static Future<Response<Map<String, dynamic>>> insertPurchase(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/purchases/insert', data: data);
  }

  /// GET /financial_transaction/purchases/excel-download
  static Future<Response<dynamic>> purchaseExcelDownload({Map<String, dynamic>? params}) {
    return HttpClient.I.get<dynamic>('/financial_transaction/purchases/excel-download', queryParameters: params);
  }
}
