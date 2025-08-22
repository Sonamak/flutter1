import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/setup/presentation/pages/connection_setup_page.dart';
import 'package:sonamak_flutter/features/setup/presentation/pages/transport_specimens_page.dart';
import 'package:sonamak_flutter/features/setup/presentation/pages/connection_diagnostics_page.dart';

class SetupInstaller {
  static void register() {
    RouteHub.register('/setup', RouteEntry(builder: (_) => const ConnectionSetupPage()));
    RouteHub.register('/setup/specimens', RouteEntry(builder: (_) => const TransportSpecimensPage()));
    RouteHub.register('/setup/diagnostics', RouteEntry(builder: (_) => const ConnectionDiagnosticsPage()));
  }
}
