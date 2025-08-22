
class Branch {
  final int id;
  final String name;
  final String? phone;
  final String? countryCode;
  final String? location;
  final String? map;
  final String? from;
  final String? to;
  final Map<String, dynamic> raw;
  const Branch({
    required this.id,
    required this.name,
    this.phone,
    this.countryCode,
    this.location,
    this.map,
    this.from,
    this.to,
    this.raw = const {},
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    String? str(k) => json[k]?.toString();
    final working = json['workingHours'] is Map ? json['workingHours'] as Map : {};
    return Branch(
      id: toInt(json['id']),
      name: json['name']?.toString() ?? '',
      phone: str('phone'),
      countryCode: str('countryCode') ?? str('country_code'),
      location: str('location'),
      map: str('map'),
      from: working['from']?.toString() ?? str('from'),
      to: working['to']?.toString() ?? str('to'),
      raw: json,
    );
  }

  Map<String, dynamic> toUpdatePayload() {
    final m = <String, dynamic>{'id': id, 'name': name};
    if (phone != null) m['phone'] = phone;
    if (countryCode != null) m['countryCode'] = countryCode;
    if (location != null) m['location'] = location;
    if (map != null) m['map'] = map;
    if (from != null || to != null) m['workingHours'] = {'from': from, 'to': to};
    return m;
  }
}
