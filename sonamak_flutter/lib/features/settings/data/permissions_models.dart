
class RoleItem {
  final int value;
  final String label;
  const RoleItem({required this.value, required this.label});

  factory RoleItem.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return RoleItem(value: toInt(json['id'] ?? json['value']), label: (json['name'] ?? json['label'] ?? '').toString());
  }
}

class PermissionSetting {
  final int id;
  final String name;
  final String? group;
  final bool checked;
  const PermissionSetting({required this.id, required this.name, this.group, this.checked = false});

  factory PermissionSetting.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    final name = (json['name'] ?? json['label'] ?? '').toString();
    final group = (json['group'] ?? json['module'] ?? '').toString();
    final checked = (json['checked'] == true) || (json['checked']?.toString() == '1') || (json['is_checked'] == true) || (json['active'] == true);
    return PermissionSetting(id: toInt(json['id']), name: name, group: group.isEmpty ? null : group, checked: checked);
  }
}
