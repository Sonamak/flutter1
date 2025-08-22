
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class ClinicsApi {
  static Future<Response<List<dynamic>>> getAll() =>
      HttpClient.I.get<List<dynamic>>('/sonamak-clinics');

  /// Create or update a clinic; React sends {...fields, plan: plan.value, phone: phone.slice(countryCode.length)}
  static Future<Response<Map<String, dynamic>>> handle(Map<String, dynamic> data) =>
      HttpClient.I.post<Map<String, dynamic>>('/sonamak-clinics/handle', data: data);

  /// Add extras to a clinic subscription/cart
  static Future<Response<Map<String, dynamic>>> addExtra(Map<String, dynamic> data) =>
      HttpClient.I.post<Map<String, dynamic>>('/sonamak-clinics/add-extra', data: data);

  /// Suspend/unsuspend a clinic: { id, active: boolean }
  static Future<Response<Map<String, dynamic>>> changeSuspend(Map<String, dynamic> data) =>
      HttpClient.I.post<Map<String, dynamic>>('/sonamak-clinics/change-suspend', data: data);

  /// Update subscription row(s) from EditableTable
  static Future<Response<Map<String, dynamic>>> updateSubscription(Map<String, dynamic> data) =>
      HttpClient.I.post<Map<String, dynamic>>('/sonamak-clinics/update', data: data);

  /// List add-on extras by country code (e.g., 'EG', 'US')
  static Future<Response<List<dynamic>>> getExtras(String country) =>
      HttpClient.I.get<List<dynamic>>('/extras', queryParameters: {'country': country});
}
