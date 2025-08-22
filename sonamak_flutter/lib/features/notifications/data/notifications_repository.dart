
import 'package:sonamak_flutter/features/notifications/data/notifications_api.dart';
import 'package:sonamak_flutter/features/notifications/data/notifications_models.dart';

class NotificationsRepository {
  Future<List<NotificationItem>> list() async {
    final res = await NotificationsApi.getNotifications();
    final list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map((e) => NotificationItem(e)).toList(growable: false);
  }

  Future<void> markAllRead() => NotificationsApi.readNotifications();

  Future<Map<String, dynamic>> calendarEvent(int id) async {
    final res = await NotificationsApi.getCalendarEvent(id);
    return res.data ?? <String, dynamic>{};
  }
}
