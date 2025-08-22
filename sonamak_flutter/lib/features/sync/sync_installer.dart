import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/sync/presentation/pages/sync_center_page.dart';

class SyncInstaller {
  static void register() {
    RouteHub.register('/sync-center', RouteEntry(builder: (ctx) => const SyncCenterPage()));
  }
}
