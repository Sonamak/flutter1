import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/reliability_qa/presentation/pages/reliability_qa_page.dart';

class ReliabilityInstaller {
  static void register() {
    RouteHub.register('/reliability/qa', RouteEntry(builder: (_) => const ReliabilityQaPage()));
  }
}
