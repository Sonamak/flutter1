
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class ReportsApi {
  // Examination
  static Future<Response<dynamic>> examinationExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/examination/excel-download', queryParameters: params);

  static Future<Response<dynamic>> examinationInvoice({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/examination/invoice', queryParameters: params);

  // Finance purchases export (transactions purchases)
  static Future<Response<dynamic>> purchasesExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/financial_transaction/purchases/excel-download', queryParameters: params);

  static Future<Response<Map<String, dynamic>>> invoiceData({
    required dynamic id,
    required dynamic patientId,
    String? createdAt,
    dynamic invoice,
  }) {
    final params = <String, dynamic>{'id': id, 'patientId': patientId, if (createdAt != null) 'created_at': createdAt, if (invoice != null) 'invoice': invoice};
    return HttpClient.I.get<Map<String, dynamic>>('/financial_transaction/invoice-data', queryParameters: params);
  }

  static Future<Response<Map<String, dynamic>>> editInvoicePrice(Map<String, dynamic> data) =>
      HttpClient.I.post<Map<String, dynamic>>('/financial_transaction/edit-invoice', data: data);

  static Future<Response<Map<String, dynamic>>> billingInvoice(Map<String, dynamic> data) =>
      HttpClient.I.post<Map<String, dynamic>>('/sonamak-clinics/invoice', data: data);

  // Laboratory
  static Future<Response<dynamic>> laboratoryExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/laboratory/excel-download', queryParameters: params);

  static Future<Response<dynamic>> laboratoryDentistExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/laboratory/excel-dentist-laboratory', queryParameters: params);

  // Patients
  static Future<Response<dynamic>> patientsExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/patients/excel-download', queryParameters: params);

  static Future<Response<dynamic>> patientsAbsentExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/patients/absent-excel-download', queryParameters: params);

  // Procedures
  static Future<Response<dynamic>> proceduresExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/procedures/excel-download', queryParameters: params);

  // Store / Inventory
  static Future<Response<dynamic>> storeExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/store/excel-download', queryParameters: params);

  static Future<Response<dynamic>> storeExpireExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/store/excel-expire', queryParameters: params);

  static Future<Response<dynamic>> storePaymentExcel({Map<String, dynamic>? params}) =>
      HttpClient.I.get<dynamic>('/store/payment-excel', queryParameters: params);
}
