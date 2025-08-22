import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/dashboard/presentation/pages/dashboard_page.dart';

class DashboardInstaller {
  static void register() {
    RouteHub.register('/admin/dashboard', RouteEntry(builder: (_) => const DashboardPage()));
  }
}
