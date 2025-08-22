import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/permissions/permission_service.dart';

class ActionGate extends StatelessWidget {
  const ActionGate({
    super.key,
    required this.anyOf,
    required this.child,
    this.hideIfUnauthorized = false,
    this.tooltipWhenDisabled = 'You do not have permission to perform this action.',
  });

  final List<int> anyOf;
  final Widget child;
  final bool hideIfUnauthorized;
  final String tooltipWhenDisabled;

  @override
  Widget build(BuildContext context) {
    final ok = PermissionService.hasAny(anyOf);
    if (ok) return child;
    if (hideIfUnauthorized) return const SizedBox.shrink();
    return Tooltip(
      message: tooltipWhenDisabled,
      child: IgnorePointer(
        ignoring: true,
        child: Opacity(opacity: 0.5, child: child),
      ),
    );
  }
}
