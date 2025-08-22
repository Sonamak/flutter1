
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../golden_test_config.dart';
import 'package:sonamak_flutter/app/localization/l10n.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/home_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/about_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/pricing_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/contact_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/policy_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/compliance_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/terms_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/patient_data_page.dart';

Widget wrapLocales(Widget child) {
  return MaterialApp(
    localizationsDelegates: L10n.delegates,
    supportedLocales: L10n.supportedLocales,
    home: RtlBuilder(child: child),
  );
}

void main() {
  testGoldens('Landing pages — freeze (desktop)', (tester) async {
    final pages = <String, Widget>{
      'home': const HomePage(),
      'about': const AboutPage(),
      'pricing': const PricingPage(),
      'contact': const ContactPage(),
      'policy': const PolicyPage(),
      'compliance': const CompliancePage(),
      'terms': const TermsPage(),
      'patient_information': const PatientDataPage(),
    };

    final widgets = pages.entries.map((e) => wrapLocales(e.value)).toList();
    await tester.pumpWidgetBuilder(Column(children: widgets.map((w) => Expanded(child: w)).toList()), surfaceSize: const Size(1440, 900 * 2));
    await multiScreenGolden(tester, 'landing_freeze_desktop', devices: [desktop]);
  });
}
