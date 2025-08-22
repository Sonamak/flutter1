import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/mobile_qa/presentation/pages/mobile_qa_page.dart';

class MobileInstaller {
  static void register() {
    RouteHub.register('/mobile/qa', RouteEntry(builder: (_) => const MobileQaPage()));
  }
}
