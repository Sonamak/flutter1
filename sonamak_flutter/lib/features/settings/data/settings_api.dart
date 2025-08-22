
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class SettingsApi {
  static Future<Response<dynamic>> permission(int role) =>
      HttpClient.I.get('/settings/permission', queryParameters: {'role': role});
  static Future<Response<dynamic>> roleCreate(Map<String, dynamic> data) =>
      HttpClient.I.post('/settings/role/create', data: data);
  static Future<Response<dynamic>> roleUpdate(Map<String, dynamic> data) =>
      HttpClient.I.post('/settings/role/update', data: data);

  static Future<Response<dynamic>> profileInformation() => HttpClient.I.get('/settings/profile');
  static Future<Response<dynamic>> profileSettingsUpdate(FormData data) => HttpClient.I.post('/settings/update', data: data);

  static Future<Response<dynamic>> clinicSettings() => HttpClient.I.get('/settings/clinic');
  static Future<Response<dynamic>> clinicSettingsUpdate(FormData data) => HttpClient.I.post('/settings/clinic/update', data: data);
  static Future<Response<dynamic>> createClinicDemo() => HttpClient.I.post('/settings/clinic/demo');

  static Future<Response<dynamic>> teamSettings() => HttpClient.I.get('/settings/team');
  static Future<Response<dynamic>> teamSettingsUpdate(FormData data) => HttpClient.I.post('/settings/team/update', data: data);

  static Future<Response<dynamic>> handleAutoRenewal(bool active) => HttpClient.I.post('/settings/change-autorenewal', data: {'active': active});

  static Future<Response<dynamic>> requestBackup() => HttpClient.I.get('/settings/backup');
  static Future<Response<dynamic>> downloadBackup() => HttpClient.I.post('/settings/backup-download');
}
