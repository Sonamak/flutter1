
class PermissionService {
  static final Set<int> _perms = <int>{};

  static void setPermissions(Iterable<int> ids) {
    _perms
      ..clear()
      ..addAll(ids);
  }

  static bool hasAny(Iterable<int> ids) {
    for (final id in ids) {
      if (_perms.contains(id)) return true;
    }
    return false;
  }

  static bool hasAll(Iterable<int> ids) {
    for (final id in ids) {
      if (!_perms.contains(id)) return false;
    }
    return true;
  }
}
