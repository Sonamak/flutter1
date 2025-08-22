
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';

class UnauthorizedInstaller {
  static void register() {
    RouteHub.register('/unauthorized', RouteEntry(builder: (_) => const _UnauthorizedPage()));
  }
}

class _UnauthorizedPage extends StatelessWidget {
  const _UnauthorizedPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Unauthorized')),
    );
  }
}
