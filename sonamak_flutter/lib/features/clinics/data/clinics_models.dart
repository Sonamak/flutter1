
class Clinic {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? subdomain;
  final int? currencyId;
  final bool active;
  final String? status;
  final List<Subscription> subscriptions;
  final Map<String, dynamic> raw;

  const Clinic({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.subdomain,
    this.currencyId,
    required this.active,
    this.status,
    this.subscriptions = const [],
    this.raw = const {},
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    bool toBool(v) {
      if (v is bool) return v;
      final s = v?.toString().toLowerCase();
      return s == '1' || s == 'true';
    }
    final subs = <Subscription>[];
    final ss = json['subscriptions'];
    if (ss is List) {
      for (final e in ss) {
        if (e is Map<String, dynamic>) subs.add(Subscription.fromJson(e));
      }
    }
    return Clinic(
      id: toInt(json['id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      subdomain: json['subdomain']?.toString(),
      currencyId: json['currency_id'] is int ? json['currency_id'] as int : int.tryParse('${json['currency_id']}'),
      active: toBool(json['active'] ?? json['is_active']),
      status: json['status']?.toString(),
      subscriptions: subs,
      raw: json,
    );
  }
}

class Subscription {
  final int id;
  final String name;
  final String? createdAt;
  final num? price;
  final int? duration; // months
  final String? status; // "1" success, else declined
  final Map<String, dynamic> raw;

  const Subscription({
    required this.id,
    required this.name,
    this.createdAt,
    this.price,
    this.duration,
    this.status,
    this.raw = const {},
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    num? toNum(v) => v is num ? v : num.tryParse('$v');
    return Subscription(
      id: toInt(json['id']),
      name: json['name']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
      price: toNum(json['price']),
      duration: toInt(json['duration']),
      status: json['status']?.toString(),
      raw: json,
    );
  }

  Map<String, dynamic> toUpdatePayload() {
    final m = <String, dynamic>{'id': id, 'name': name};
    if (createdAt != null) m['createdAt'] = createdAt;
    if (price != null) m['price'] = price;
    if (duration != null) m['duration'] = duration;
    if (status != null) m['status'] = status;
    return m;
  }
}

class ExtraItem {
  final int id;
  final String name;
  final num? price;
  final String? value;
  final Map<String, dynamic> raw;
  const ExtraItem({required this.id, required this.name, this.price, this.value, this.raw = const {}});

  factory ExtraItem.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    num? toNum(v) => v is num ? v : num.tryParse('$v');
    return ExtraItem(
      id: toInt(json['id']),
      name: json['name']?.toString() ?? '',
      price: toNum(json['price']),
      value: json['value']?.toString(),
      raw: json,
    );
  }
}
