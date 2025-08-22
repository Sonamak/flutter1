
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/settings/presentation/pages/users_permissions_page.dart';

class SettingsInstaller {
  static void register() {
    RouteHub.register('/admin/settings/permissions', RouteEntry(builder: (_) => const UsersPermissionsPage()));
  }
}
