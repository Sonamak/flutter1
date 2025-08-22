class MemberLite {
  final int id;
  final String name;
  final String? role;
  final String? phone;
  const MemberLite({required this.id, required this.name, this.role, this.phone});

  factory MemberLite.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return MemberLite(
      id: toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      role: (json['role'] ?? json['role_name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }
}

class MemberDetail {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? role;
  const MemberDetail({required this.id, required this.name, this.email, this.phone, this.role});

  factory MemberDetail.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return MemberDetail(
      id: toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? json['role_name'] ?? '').toString(),
    );
  }
}
