
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/clinics/presentation/pages/clinics_page.dart';

class ClinicsInstaller {
  static void register() {
    RouteHub.register('/admin/clinics', RouteEntry(builder: (_) => const ClinicsPage()));
  }
}
