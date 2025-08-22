import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/settings/data/settings_models.dart';
import 'package:sonamak_flutter/features/settings/data/settings_repository.dart';

class UsersPermissionsController extends ChangeNotifier {
  final SettingsRepository _repo = SettingsRepository();

  List<RoleItem> roles = const [];
  List<PermissionSetting> permissions = const [];
  List<PermissionOption> options = const [];

  RoleItem? selectedRole;

  Future<void> loadRoles() async {
    roles = await _repo.listRoles();
    notifyListeners();
  }

  Future<void> selectRole(RoleItem role) async {
    selectedRole = role;
    permissions = await _repo.loadPermissions(role.idAsInt);

    // Build tree/options; groups can be null — guard with ?? []
    options = permissions
        .map((p) => PermissionOption(
      id: p.id,
      name: p.name,
      selected: p.enabled,
      groups: p.groups,
    ))
        .toList(growable: false);

    notifyListeners();
  }

  Future<void> applySelected(List<int> permissionIds) async {
    final roleId = selectedRole?.idAsInt ?? 0; // ✅ String → int
    await _repo.updateRole(roleId, permissionIds);
  }

  Future<void> createRole(String name) async {
    await _repo.createRole(name);
    await loadRoles();
  }
}
