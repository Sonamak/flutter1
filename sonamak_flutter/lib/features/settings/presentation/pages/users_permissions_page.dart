import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/settings/controllers/users_permissions_controller.dart';
import 'package:sonamak_flutter/features/settings/data/settings_models.dart';

/// Rewritten without the `provider` package to avoid missing dependency.
class UsersPermissionsPage extends StatefulWidget {
  const UsersPermissionsPage({super.key});

  @override
  State<UsersPermissionsPage> createState() => _UsersPermissionsPageState();
}

class _UsersPermissionsPageState extends State<UsersPermissionsPage> {
  final c = UsersPermissionsController();
  bool _loadingRoles = true;
  bool _loadingPerms = false;

  @override
  void initState() {
    super.initState();
    c.loadRoles().then((_) => setState(() => _loadingRoles = false));
  }

  Future<void> _onRoleSelected(RoleItem role) async {
    setState(() => _loadingPerms = true);
    await c.selectRole(role);
    setState(() => _loadingPerms = false);
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Users & Permissions')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _loadingRoles
                  ? const LinearProgressIndicator()
                  : DropdownButton<RoleItem>(
                value: c.selectedRole,
                hint: const Text('Select role'),
                items: c.roles
                    .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                    .toList(),
                onChanged: (r) => r == null ? null : _onRoleSelected(r),
              ),
            ),
            if (_loadingPerms) const LinearProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: c.options.length,
                itemBuilder: (_, i) {
                  final o = c.options[i];
                  final groups = o.groups ?? const <String>[]; // ✅ null-safe
                  return CheckboxListTile(
                    title: Text(o.label),
                    subtitle: groups.isEmpty ? null : Text(groups.join(', ')),
                    value: o.enabled,
                    onChanged: (_) {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
