
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/hr/presentation/pages/users_page.dart';
import 'package:sonamak_flutter/features/hr/presentation/pages/users_permissions_page.dart';
import 'package:sonamak_flutter/features/hr/presentation/pages/schedules_page.dart';

class HrInstaller {
  static void register() {
    RouteHub.register('/admin/users', RouteEntry(builder: (_) => const UsersPage()));
    RouteHub.register('/admin/users/permissions', RouteEntry(builder: (_) => const UsersPermissionsPage()));
    RouteHub.register('/admin/schedules', RouteEntry(builder: (_) => const SchedulesPage()));
  }
}
