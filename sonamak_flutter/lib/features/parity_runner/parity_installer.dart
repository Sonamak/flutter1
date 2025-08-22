import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/parity_runner/presentation/pages/dashboard_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner/presentation/pages/calendar_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner/presentation/pages/patients_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner/presentation/pages/finance_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner/presentation/pages/store_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner/presentation/pages/laboratory_parity_page.dart';
import 'package:sonamak_flutter/features/parity_runner/presentation/pages/viewers_parity_page.dart';

class ParityInstaller {
  static void register() {
    RouteHub.register('/parity/batch1/dashboard', RouteEntry(builder: (_) => const DashboardParityPage()));
    RouteHub.register('/parity/batch1/calendar', RouteEntry(builder: (_) => const CalendarParityPage()));
    RouteHub.register('/parity/batch1/patients', RouteEntry(builder: (_) => const PatientsParityPage()));
    RouteHub.register('/parity/batch1/finance', RouteEntry(builder: (_) => const FinanceParityPage()));
    RouteHub.register('/parity/batch1/store', RouteEntry(builder: (_) => const StoreParityPage()));
    RouteHub.register('/parity/batch1/lab', RouteEntry(builder: (_) => const LaboratoryParityPage()));
    RouteHub.register('/parity/batch1/viewers', RouteEntry(builder: (_) => const ViewersParityPage()));
  }
}
