import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/patients_probe/presentation/pages/patients_probe_page.dart';

class PatientsProbeInstaller {
  static void register() {
    RouteHub.register('/patients/probe', RouteEntry(builder: (_) => const PatientsProbePage()));
  }
}