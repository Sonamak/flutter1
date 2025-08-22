import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/security_qa/presentation/pages/security_qa_page.dart';

class SecurityInstaller {
  static void register() {
    RouteHub.register('/security/qa', RouteEntry(builder: (_) => const SecurityQaPage()));
  }
}
