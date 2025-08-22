
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class InsuranceApi {
  // Companies
  static Future<Response<List<dynamic>>> getInsurances({int type = 1}) {
    return HttpClient.I.get<List<dynamic>>('/insurances/all-insurances', queryParameters: {'type': type});
  }

  static Future<Response<Map<String, dynamic>>> createInsurance(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/insurances/store', data: data);
  }

  static Future<Response<Map<String, dynamic>>> updateInsurance(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/insurances/update-insurance', data: data);
  }

  static Future<Response<Map<String, dynamic>>> deleteInsurance(int id) {
    return HttpClient.I.post<Map<String, dynamic>>('/insurances/delete-insurance/$id');
  }

  static Future<Response<List<dynamic>>> getInsuranceClasses(int insuranceId) {
    return HttpClient.I.get<List<dynamic>>('/insurances/insurance-classes/$insuranceId');
  }

  static Future<Response<Map<String, dynamic>>> addSegmentInsurance(Map<String, dynamic> data) {
    // segments (create/update segment for an insurance)
    return HttpClient.I.post<Map<String, dynamic>>('/insurances/segments', data: data);
  }

  // Claims
  static Future<Response<List<dynamic>>> claimData({required int insuranceId, String? from, String? to, required int claimStatus}) {
    final data = {'id': insuranceId, 'from': from, 'to': to, 'claim_status': claimStatus};
    return HttpClient.I.post<List<dynamic>>('/insurances/claim-data', data: data);
  }

  static Future<Response<Map<String, dynamic>>> generateClaim({required int insuranceId, required List<int> ids}) {
    return HttpClient.I.post<Map<String, dynamic>>('/insurances/generate-claim', data: {'insurance_id': insuranceId, 'ids': ids});
  }

  static Future<Response<Map<String, dynamic>>> payClaim({required int insuranceId, required List<Map<String, dynamic>> claimed, dynamic paid}) {
    return HttpClient.I.post<Map<String, dynamic>>('/insurances/pay-claim', data: {'insurance_id': insuranceId, 'claimed': claimed, 'paid': paid});
  }

  static Future<Response<List<dynamic>>> getInsurancePayments(int insuranceId, int type) {
    // type: 1 = paid claims, 2 = required claims (per React usage)
    return HttpClient.I.get<List<dynamic>>('/insurances/payments', queryParameters: {'insurance_id': insuranceId, 'type': type});
  }

  // Exports
  static Future<Response<dynamic>> insuranceExcelDownload({Map<String, dynamic>? params}) {
    return HttpClient.I.get<dynamic>('/insurances/excel-download', queryParameters: params);
  }

  static Future<Response<dynamic>> socialInsuranceExcelDownload({Map<String, dynamic>? params}) {
    return HttpClient.I.get<dynamic>('/insurances/social-excel-download', queryParameters: params);
  }
}
