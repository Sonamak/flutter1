import 'package:flutter/widgets.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/auth/auth_installer.dart';
import 'package:sonamak_flutter/features/setup/presentation/pages/connection_setup_page.dart';
import 'package:sonamak_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:sonamak_flutter/app/admin/admin_hub_installer.dart';
import 'package:sonamak_flutter/app/admin/pages/admin_home_page.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';

class NavigationInstaller {
  static void installRouter() {
    AuthInstaller.register();
    AdminHubInstaller.register();
    RouteHub.register('/admin', RouteEntry(builder: (_) => const AdminHomePage()));
    RouteHub.register('/admin/dashboard', RouteEntry(builder: (_) => const DashboardPage()));
    RouteHub.register('/setup', RouteEntry(builder: (_) => const ConnectionSetupPage()));
    RouteHub.register('/', RouteEntry(builder: (_) => const _Gate()));
  }
}

class _Gate extends StatefulWidget {
  const _Gate();
  @override
  State<_Gate> createState() => _GateState();
}

class _GateState extends State<_Gate> {
  @override
  void initState() { super.initState(); _decide(); }
  Future<void> _decide() async {
    final token = await SecureStorage.read('auth_token');
    final dest = (token != null && token.isNotEmpty) ? '/admin' : '/login';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RouteHub.navKey.currentState?.pushReplacementNamed(dest);
    });
  }
  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: Text('Loading…')),
  );
}