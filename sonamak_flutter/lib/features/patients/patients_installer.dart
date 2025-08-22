
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/patients/presentation/pages/patient_list_page.dart';
import 'package:sonamak_flutter/features/patients/presentation/pages/patient_profile_page.dart';

class PatientsInstaller {
  static void register() {
    RouteHub.register('/admin/patients', RouteEntry(builder: (_) => const PatientListPage()));
    // Profile page cannot receive query params via RouteHub; use Navigator push from list to pass id.
    RouteHub.register('/admin/patient', RouteEntry(builder: (_) => const PatientProfilePage()));
  }
}
