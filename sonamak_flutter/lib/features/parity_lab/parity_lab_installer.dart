import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/parity_lab/presentation/pages/parity_lab_page.dart';

class ParityLabInstaller {
  static void register() {
    RouteHub.register('/parity/lab', RouteEntry(builder: (_) => const ParityLabPage()));
  }
}
