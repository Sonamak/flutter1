
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/reports/presentation/pages/reports_hub_page.dart';
import 'package:sonamak_flutter/features/reports/presentation/pages/invoice_page.dart';

class ReportsInstaller {
  static void register() {
    RouteHub.register('/admin/reports', RouteEntry(builder: (_) => const ReportsHubPage()));
    RouteHub.register('/admin/reports/invoice', RouteEntry(builder: (_) => const InvoicePage()));
  }
}
