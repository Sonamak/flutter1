
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:sonamak_flutter/features/logs/presentation/pages/logs_page.dart';

class NotificationsAndLogsInstaller {
  static void register() {
    RouteHub.register('/admin/notifications', RouteEntry(builder: (_) => const NotificationsPage()));
    RouteHub.register('/admin/logs', RouteEntry(builder: (_) => const LogsPage()));
  }
}
