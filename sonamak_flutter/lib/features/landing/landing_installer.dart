import 'package:sonamak_flutter/core/navigation/route_hub.dart';

// Landing pages
import 'package:sonamak_flutter/features/landing/presentation/pages/home_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/about_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/pricing_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/contact_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/policy_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/compliance_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/terms_page.dart';
import 'package:sonamak_flutter/features/landing/presentation/pages/patient_data_page.dart';

/// Registers the public (unauthenticated) site routes so the Flutter app
/// exposes the same landing pages as the React app.
/// NOTE: RouteHub.register() uses last-write-wins; registering '/' here will
/// intentionally override any previous '/' mapping (e.g., an auth gate).
class LandingInstaller {
  static void register() {
    // Public landing routes (must match React)
    RouteHub.register('/', RouteEntry(builder: (_) => const HomePage()));
    RouteHub.register('/about', RouteEntry(builder: (_) => const AboutPage()));
    RouteHub.register('/pricing', RouteEntry(builder: (_) => const PricingPage()));
    RouteHub.register('/contact', RouteEntry(builder: (_) => const ContactPage()));
    RouteHub.register('/policy', RouteEntry(builder: (_) => const PolicyPage()));
    RouteHub.register('/compliance', RouteEntry(builder: (_) => const CompliancePage()));
    RouteHub.register('/terms', RouteEntry(builder: (_) => const TermsPage()));
    RouteHub.register('/patient-information', RouteEntry(builder: (_) => const PatientDataPage()));
  }
}
