import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/app/admin/pages/admin_home_page.dart';

// Core admin modules
import 'package:sonamak_flutter/features/dashboard/dashboard_installer.dart';
import 'package:sonamak_flutter/features/calendar/calendar_installer.dart';
import 'package:sonamak_flutter/features/patients/patients_installer.dart';
import 'package:sonamak_flutter/features/members/members_installer.dart';
import 'package:sonamak_flutter/features/lab/lab_installer.dart';
import 'package:sonamak_flutter/features/store/store_installer.dart';
import 'package:sonamak_flutter/features/finance/finance_installer.dart';
import 'package:sonamak_flutter/features/insurance/insurance_installer.dart';
import 'package:sonamak_flutter/features/settings/settings_installer.dart';

import 'package:sonamak_flutter/features/booking/booking_installer.dart';

// Other admin areas already present
import 'package:sonamak_flutter/features/reports/reports_installer.dart';
import 'package:sonamak_flutter/features/notifications_and_logs_installer.dart';
import 'package:sonamak_flutter/features/settings_and_branches_installer.dart';
import 'package:sonamak_flutter/features/clinics/clinics_installer.dart';
import 'package:sonamak_flutter/features/hr/hr_installer.dart';

import 'package:flutter/widgets.dart';
import 'package:sonamak_flutter/features/members/presentation/pages/members_list_page.dart';
import 'package:sonamak_flutter/features/finance/presentation/pages/payment_slip_page.dart';

class AdminHubInstaller {
  static void register() {
    // 1) Register module routes
    DashboardInstaller.register();
    // Ensure booking calendar route is available
    BookingInstaller.install();
    CalendarInstaller.register();
    PatientsInstaller.register();
    MembersInstaller.install();              // note: this installer uses 'install()' not 'register()'
    LabInstaller.register();
    StoreInstaller.register();
    FinanceInstaller.register();
    InsuranceInstaller.register();
    SettingsInstaller.register();

    ReportsInstaller.register();
    NotificationsAndLogsInstaller.register();
    SettingsAndBranchesInstaller.register();
    ClinicsInstaller.register();
    HrInstaller.register();

    // 2) Admin landing
    RouteHub.register('/admin', RouteEntry(builder: (_) => const AdminHomePage()));

    // 3) Aliases for dashboard buttons that don't match feature routes
    // '/admin/members' alias -> Members list
    RouteHub.register('/admin/members', const RouteEntry(builder: _membersList));
    // '/admin/finance' alias -> Payment slip main page (most used finance screen)
    RouteHub.register('/admin/finance', const RouteEntry(builder: _financeHome));
  }

  static Widget _membersList(BuildContext context) => const MembersListPage();

  static Widget _financeHome(BuildContext context) {
    // Accept optional args if any are passed later
    return const PaymentSlipPage(args: {});
  }
}
