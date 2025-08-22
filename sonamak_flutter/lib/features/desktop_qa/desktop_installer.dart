import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/desktop_qa/presentation/pages/desktop_qa_page.dart';

class DesktopInstaller {
  static void register() {
    RouteHub.register('/desktop/qa', RouteEntry(builder: (_) => const DesktopQaPage()));
  }
}
