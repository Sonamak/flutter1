
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class NotificationsApi {
  static Future<Response<List<dynamic>>> getNotifications() =>
      HttpClient.I.get<List<dynamic>>('/notifications/all-data');

  static Future<Response<Map<String, dynamic>>> readNotifications() =>
      HttpClient.I.post<Map<String, dynamic>>('/notifications/read');

  static Future<Response<Map<String, dynamic>>> getCalendarEvent(int id) =>
      HttpClient.I.get<Map<String, dynamic>>('/calendar/event/$id');
}
