
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/insurance/presentation/pages/insurance_companies_page.dart';

class InsuranceInstaller {
  static void register() {
    RouteHub.register('/admin/insurance', RouteEntry(builder: (_) => const InsuranceCompaniesPage()));
  }
}
