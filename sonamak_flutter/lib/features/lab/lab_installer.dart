
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/lab/presentation/pages/lab_page.dart';

class LabInstaller {
  static void register() {
    RouteHub.register('/admin/lab', RouteEntry(builder: (_) => const LabPage()));
  }
}
