
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/app.dart';
import 'package:sonamak_flutter/core/navigation/navigation_installer.dart';
import 'package:sonamak_flutter/features/landing/landing_installer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NavigationInstaller.installRouter();
  // Ensure public landing routes are available and '/' maps to HomePage
  LandingInstaller.register();
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) => const App();
}
