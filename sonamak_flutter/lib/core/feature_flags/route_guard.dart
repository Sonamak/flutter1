import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/feature_flags/feature_flags.dart';

/// Wrap a route builder with a feature-flag check.
Route<dynamic> guardedRoute({
  required String flag,
  required String path,
  required WidgetBuilder builder,
}) {
  return MaterialPageRoute(
    settings: RouteSettings(name: path),
    builder: (ctx) => FeatureFlags.I.isEnabled(flag)
        ? builder(ctx)
        : const _FeatureDisabledPage(),
  );
}

class _FeatureDisabledPage extends StatelessWidget {
  const _FeatureDisabledPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Feature disabled')),
        body: const Center(child: Text('This feature is currently disabled.')),
      );
}
