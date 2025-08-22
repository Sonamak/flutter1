class PatientLite {
  final int id;
  final String name;
  final String? phone;
  const PatientLite({required this.id, required this.name, this.phone});

  factory PatientLite.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return PatientLite(
      id: toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }
}

class PatientProfile {
  final int id;
  final String name;
  final String? phone;
  const PatientProfile({required this.id, required this.name, this.phone});
  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return PatientProfile(
      id: toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }
}
