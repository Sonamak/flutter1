import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/dentist_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/dermatology_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/tumors_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/tumorsadv_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/radiation_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/referrals_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/scancenters_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/agreements_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/appointments_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/clinicrooms_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/obstetrics_batch3_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner_batch3/presentation/pages/support_batch3_parity_page.dart';

class ParityBatch3Installer {
  static void register() {
    RouteHub.register('/parity/batch3/dentist', RouteEntry(builder: (_) => const DentistBatch3ParityPage()));
    RouteHub.register('/parity/batch3/dermatology', RouteEntry(builder: (_) => const DermatologyBatch3ParityPage()));
    RouteHub.register('/parity/batch3/tumors', RouteEntry(builder: (_) => const TumorsBatch3ParityPage()));
    RouteHub.register('/parity/batch3/tumors-adv', RouteEntry(builder: (_) => const TumorsAdvBatch3ParityPage()));
    RouteHub.register('/parity/batch3/radiation', RouteEntry(builder: (_) => const RadiationBatch3ParityPage()));
    RouteHub.register('/parity/batch3/referrals', RouteEntry(builder: (_) => const ReferralsBatch3ParityPage()));
    RouteHub.register('/parity/batch3/scan-centers', RouteEntry(builder: (_) => const ScanCentersBatch3ParityPage()));
    RouteHub.register('/parity/batch3/agreements', RouteEntry(builder: (_) => const AgreementsBatch3ParityPage()));
    RouteHub.register('/parity/batch3/appointments', RouteEntry(builder: (_) => const AppointmentsBatch3ParityPage()));
    RouteHub.register('/parity/batch3/clinic-rooms', RouteEntry(builder: (_) => const ClinicRoomsBatch3ParityPage()));
    RouteHub.register('/parity/batch3/obstetrics', RouteEntry(builder: (_) => const ObstetricsBatch3ParityPage()));
    RouteHub.register('/parity/batch3/support', RouteEntry(builder: (_) => const SupportBatch3ParityPage()));
  }
}
