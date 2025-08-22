
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/hr/data/hr_models.dart';
import 'package:sonamak_flutter/features/hr/data/hr_repository.dart';

class PermissionsState {
  final bool loading;
  final List<PermissionNode> tree;
  final int role;
  final Object? error;

  const PermissionsState({required this.loading, this.tree = const [], this.role = 0, this.error});
  factory PermissionsState.initial() => const PermissionsState(loading: false);
}

class PermissionsController extends ChangeNotifier {
  PermissionsController(this._repo);
  final HrRepository _repo;

  PermissionsState _state = PermissionsState.initial();
  PermissionsState get state => _state;

  Future<void> load(int role) async {
    _state = PermissionsState(loading: true, role: role);
    notifyListeners();
    try {
      final t = await _repo.permissionTree(role);
      _state = PermissionsState(loading: false, role: role, tree: t);
      notifyListeners();
    } catch (e) {
      _state = PermissionsState(loading: false, role: role, error: e);
      notifyListeners();
    }
  }

  Future<bool> roleCreate(String name) async {
    try {
      await _repo.roleCreate({'name': name});
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> roleUpdate(int role, List<PermissionNode> tree) async {
    try {
      // flatten allowed nodes by key
      List<String> allowed = [];
      void walk(PermissionNode n) {
        if (n.allowed) allowed.add(n.key);
        for (final c in n.children) walk(c);
      }
      for (final n in tree) walk(n);
      await _repo.roleUpdate({'role': role, 'permissions': allowed});
      return true;
    } catch (_) {
      return false;
    }
  }
}
