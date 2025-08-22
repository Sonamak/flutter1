class PermissionNode {
  final int id;
  final String key;       // stable key
  final String label;     // display label
  final bool allowed;     // enabled/checked flag
  final String? group;
  final List<PermissionNode> children;

  const PermissionNode({
    required this.id,
    required this.key,
    required this.label,
    required this.allowed,
    this.group,
    this.children = const [],
  });

  // Backwards-compat getters used by controllers/pages
  bool get checked => allowed;
  String get name => label;

  PermissionNode copyWith({
    int? id,
    String? key,
    String? label,
    bool? allowed,
    String? group,
    List<PermissionNode>? children,
  }) =>
      PermissionNode(
        id: id ?? this.id,
        key: key ?? this.key,
        label: label ?? this.label,
        allowed: allowed ?? this.allowed,
        group: group ?? this.group,
        children: children ?? this.children,
      );

  factory PermissionNode.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    final allowed = (json['allowed'] == true) ||
        (json['checked'] == true) ||
        (json['is_checked'] == true) ||
        (json['active'] == true) ||
        (json['enabled'] == true);
    final kids = (json['children'] as List?)
        ?.whereType<Map<String, dynamic>>()
        .map(PermissionNode.fromJson)
        .toList() ??
        const <PermissionNode>[];
    final label = (json['label'] ?? json['name'] ?? '').toString();
    final key = (json['key'] ?? json['code'] ?? label).toString();
    final group = (json['group'] ?? json['module'] ?? '').toString();
    return PermissionNode(
      id: toInt(json['id']),
      key: key,
      label: label,
      allowed: allowed,
      group: group.isEmpty ? null : group,
      children: kids,
    );
  }
}

class ScheduleItem {
  final int id;
  final String? patient;
  final String? doctor;
  final DateTime? from;
  final DateTime? to;
  final String? status;

  const ScheduleItem({required this.id, this.patient, this.doctor, this.from, this.to, this.status});

  // Backwards-compat getters used by pages (as Strings to satisfy Text widgets)
  String get title => patient ?? doctor ?? '—';
  String get start => from?.toIso8601String() ?? '';
  String get end => to?.toIso8601String() ?? '';

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    DateTime? toDt(v) => v == null ? null : DateTime.tryParse(v.toString());
    return ScheduleItem(
      id: toInt(json['id']),
      patient: (json['patient'] ?? '').toString(),
      doctor: (json['doctor'] ?? '').toString(),
      from: toDt(json['from'] ?? json['start']),
      to: toDt(json['to'] ?? json['end']),
      status: (json['status'] ?? '').toString(),
    );
  }
}

class UserLite {
  final int id;
  final String name;
  final String? role;
  final String? email;
  final String? phone;

  const UserLite({required this.id, required this.name, this.role, this.email, this.phone});

  factory UserLite.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return UserLite(
      id: toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      role: (json['role'] ?? json['role_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }
}
