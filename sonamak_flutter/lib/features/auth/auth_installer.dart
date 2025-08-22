import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/auth/presentation/pages/login_page.dart';

class AuthInstaller {
  static void register() {
    RouteHub.register('/login', RouteEntry(builder: (_) => const LoginPage()));
  }
}
