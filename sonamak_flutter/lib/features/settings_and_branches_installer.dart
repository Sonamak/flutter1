
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/branches/presentation/pages/branches_page.dart';
import 'package:sonamak_flutter/features/settings/presentation/pages/profile_settings_page.dart';
import 'package:sonamak_flutter/features/settings/presentation/pages/clinic_settings_page.dart';
import 'package:sonamak_flutter/features/settings/presentation/pages/team_settings_page.dart';

class SettingsAndBranchesInstaller {
  static void register() {
    RouteHub.register('/admin/branches', RouteEntry(builder: (_) => const BranchesPage()));
    RouteHub.register('/admin/settings/profile', RouteEntry(builder: (_) => const ProfileSettingsPage()));
    RouteHub.register('/admin/settings/clinic', RouteEntry(builder: (_) => const ClinicSettingsPage()));
    RouteHub.register('/admin/settings/team', RouteEntry(builder: (_) => const TeamSettingsPage()));
  }
}
