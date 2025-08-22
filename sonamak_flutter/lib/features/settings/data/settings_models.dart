class RoleItem {
  final String value; // stored id as string
  final String label; // display name
  const RoleItem({required this.value, required this.label});

  factory RoleItem.fromJson(Map<String, dynamic> json) {
    String toStr(v) => v == null ? '' : v.toString();
    final id = json.containsKey('value') ? json['value'] : (json['id'] ?? json['role']);
    final name = json.containsKey('label') ? json['label'] : (json['name'] ?? '');
    return RoleItem(value: toStr(id), label: toStr(name));
  }

  // Backwards-compat expected by pages
  String get name => label;
  int get idAsInt => int.tryParse(value) ?? 0;
}

class PermissionSetting {
  final int id;
  final String name;
  final List<String>? groups; // ✅ list for controllers using .map
  final bool checked;
  const PermissionSetting({required this.id, required this.name, this.groups, this.checked = false});

  // Backwards-compat getters used by controllers/pages
  bool get enabled => checked;

  factory PermissionSetting.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    List<String>? toGroups(v) {
      if (v == null) return null;
      if (v is List) return v.map((e) => e.toString()).toList();
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      return s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    final name = (json['name'] ?? json['label'] ?? '').toString();
    final checked = (json['checked'] == true) ||
        (json['checked']?.toString() == '1') ||
        (json['is_checked'] == true) ||
        (json['active'] == true) ||
        (json['enabled'] == true);

    return PermissionSetting(
      id: toInt(json['id']),
      name: name,
      groups: toGroups(json['groups'] ?? json['group'] ?? json['module']),
      checked: checked,
    );
  }
}

/// UI adapter used by UsersPermissions* controllers/pages.
/// Accepts legacy names (id/name/selected) and modern (key/label/enabled).
class PermissionOption {
  final String key;
  final String label;
  final bool enabled;
  final List<String>? groups;
  final List<PermissionOption> children;

  PermissionOption({
    String? key,
    String? label,
    bool? enabled,
    this.groups,
    List<PermissionOption>? children,
    // Legacy aliases:
    int? id,
    String? name,
    bool? selected,
  })  : key = key ?? (id?.toString() ?? name ?? ''),
        label = label ?? (name ?? key ?? ''),
        enabled = selected ?? (enabled ?? false),
        children = children ?? const [];

  // Legacy getters so old code compiles
  int get id => int.tryParse(key) ?? 0;
  String get name => label;
  bool get selected => enabled;

  PermissionOption copyWith({
    String? key,
    String? label,
    bool? enabled,
    List<String>? groups,
    List<PermissionOption>? children,
  }) =>
      PermissionOption(
        key: key ?? this.key,
        label: label ?? this.label,
        enabled: enabled ?? this.enabled,
        groups: groups ?? this.groups,
        children: children ?? this.children,
      );
}
