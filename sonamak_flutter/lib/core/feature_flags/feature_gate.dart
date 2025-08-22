import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/feature_flags/feature_flags.dart';

/// FeatureGate — hides [child] unless flag is enabled; shows [fallback] instead.
class FeatureGate extends StatelessWidget {
  const FeatureGate({super.key, required this.flag, required this.child, this.fallback});
  final String flag;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    if (FeatureFlags.I.isEnabled(flag)) return child;
    return fallback ?? const _FeatureDisabled();
  }
}

class _FeatureDisabled extends StatelessWidget {
  const _FeatureDisabled();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature unavailable')),
      body: const Center(child: Text('This feature is not enabled in your build.')),
    );
  }
}
