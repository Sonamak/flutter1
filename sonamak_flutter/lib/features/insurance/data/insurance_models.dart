
class InsuranceCompany {
  final int id;
  final String name;
  const InsuranceCompany({required this.id, required this.name});

  factory InsuranceCompany.fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0;
    final name = '${json['name'] ?? json['company'] ?? ''}';
    return InsuranceCompany(id: id, name: name);
  }
}

class InsuranceSegment {
  final String name;
  final String? phone;
  final String? approval;
  final int? pricingList;
  final String? startDate;

  const InsuranceSegment({required this.name, this.phone, this.approval, this.pricingList, this.startDate});

  factory InsuranceSegment.fromJson(Map<String, dynamic> json) {
    final name = '${json['name'] ?? ''}';
    return InsuranceSegment(
      name: name,
      phone: json['phone']?.toString(),
      approval: json['approval']?.toString(),
      pricingList: json['pricing_list'] is int ? json['pricing_list'] as int : int.tryParse('${json['pricing_list'] ?? ''}'),
      startDate: json['start_date']?.toString(),
    );
  }
}

class ClaimItem {
  final Map<String, dynamic> raw;
  final int id;
  final int count;
  final num cost;
  final num labCost;
  final num percentage;

  const ClaimItem({required this.raw, required this.id, required this.count, required this.cost, required this.labCost, required this.percentage});

  factory ClaimItem.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    num toNum(v) => v is num ? v : num.tryParse('$v') ?? 0;
    return ClaimItem(
      raw: json,
      id: toInt(json['id']),
      count: toInt(json['count'] ?? 0),
      cost: toNum(json['cost'] ?? 0),
      labCost: toNum(json['lab_cost'] ?? 0),
      percentage: toNum(json['percentage'] ?? 0),
    );
  }

  num get claimAmount => ((cost * count + labCost) * (percentage)) / 100;
}

class PaymentRow {
  final Map<String, dynamic> raw;
  const PaymentRow(this.raw);
  int get id => raw['id'] is int ? raw['id'] as int : int.tryParse('${raw['id'] ?? 0}') ?? 0;
  String? get date => raw['date']?.toString();
  num get total {
    final v = raw['total'] ?? raw['amount'];
    return v is num ? v : num.tryParse('$v') ?? 0;
  }
  int get paymentStatus {
    final v = raw['payment_status'];
    return v is int ? v : int.tryParse('$v') ?? 0;
  }
}
