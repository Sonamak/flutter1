import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/uat_center/presentation/pages/uat_center_page.dart';

class UatInstaller {
  static void register() {
    RouteHub.register('/uat/center', RouteEntry(builder: (_) => const UatCenterPage()));
  }
}
