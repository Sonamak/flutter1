
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/permissions/permission_service.dart';

class RequirePermissions extends StatelessWidget {
  const RequirePermissions({super.key, required this.anyOf, required this.child});

  final List<int> anyOf;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PermissionService.hasAny(anyOf) ? child : const _UnauthorizedView();
  }
}

class _UnauthorizedView extends StatelessWidget {
  const _UnauthorizedView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Unauthorized')),
    );
  }
}

String? guardRedirect(BuildContext context, List<int> anyOf) {
  return PermissionService.hasAny(anyOf) ? null : '/unauthorized';
}
