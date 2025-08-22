
// Fixed, defensive models for /me bootstrap parsing.
// Accepts int/string/map shapes and normalizes to safe types to prevent
// "type 'int' is not a subtype of type 'String'" crashes.

class ClinicInfo {
  final int? clinicId;
  final String? clinicName;
  final String? logoUrl;
  final String? currency;
  /// Always a String here. If server sends an int id or an object {label,value},
  /// we coerce to a human-readable string.
  final String? speciality;

  const ClinicInfo({
    this.clinicId,
    this.clinicName,
    this.logoUrl,
    this.currency,
    this.speciality,
  });

  factory ClinicInfo.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      return null;
    }

    String? parseString(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      return v.toString();
    }

    String? parseSpeciality(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;               // already a name
      if (v is int) return v.toString();       // id as string to keep model type stable
      if (v is Map) {
        final label = v['label'] ?? v['name'];
        if (label is String) return label;
        final value = v['value'];
        if (value is String) return value;
        if (value is int) return value.toString();
      }
      return v.toString();
    }

    return ClinicInfo(
      clinicId: parseInt(json['clinicId'] ?? json['clinic_id']),
      clinicName: parseString(json['clinic_name'] ?? json['clinicName']),
      logoUrl: parseString(json['logo_url'] ?? json['logoUrl']),
      currency: parseString(json['currency']),
      speciality: parseSpeciality(json['speciality']),
    );
  }

  Map<String, dynamic> toJson() => {
    'clinicId': clinicId,
    'clinic_name': clinicName,
    'logo_url': logoUrl,
    'currency': currency,
    'speciality': speciality,
  };
}

class UserInfo {
  final int? id;
  final String? name;
  final String? phone;
  final List<int> permissions;

  const UserInfo({
    this.id,
    this.name,
    this.phone,
    this.permissions = const <int>[],
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      return null;
    }

    String? parseString(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      return v.toString();
    }

    List<int> parsePermissions(dynamic v) {
      final out = <int>[];
      if (v is List) {
        for (final item in v) {
          if (item is int) {
            out.add(item);
          } else if (item is String) {
            final n = int.tryParse(item);
            if (n != null) out.add(n);
          }
          // if it's bool or anything else, ignore to avoid accidental grant/deny
        }
      }
      return out;
    }

    return UserInfo(
      id: parseInt(json['id']),
      // Some endpoints send 'user', others 'name'
      name: parseString(json['name'] ?? json['user']),
      // Backend sometimes uses user_phone; keep both and coerce to string
      phone: parseString(json['user_phone'] ?? json['phone']),
      permissions: parsePermissions(json['permissions']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'permissions': permissions,
  };
}

class MePayload {
  final UserInfo user;
  final ClinicInfo clinic;
  final Map<String, dynamic> raw;

  const MePayload({
    required this.user,
    required this.clinic,
    required this.raw,
  });

  factory MePayload.fromJson(Map<String, dynamic> json) {
    return MePayload(
      user: UserInfo.fromJson(json),
      clinic: ClinicInfo.fromJson(json),
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'clinic': clinic.toJson(),
    'raw': raw,
  };
}
