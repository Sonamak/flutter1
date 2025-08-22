
class BranchItem {
  final int id;
  final String name;
  const BranchItem({required this.id, required this.name});

  factory BranchItem.fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0;
    final name = '${json['name'] ?? json['branch_name'] ?? json['label'] ?? ''}';
    return BranchItem(id: id, name: name);
  }
}

class FinanceRow {
  final Map<String, dynamic> raw;
  const FinanceRow(this.raw);
  int get id => raw['id'] is int ? raw['id'] as int : int.tryParse('${raw['id'] ?? 0}') ?? 0;
  String get patient => '${raw['patient_name'] ?? raw['patient'] ?? ''}';
  String? get date => raw['date']?.toString() ?? raw['created_at']?.toString();
  num get amount {
    final v = raw['amount'] ?? raw['total'] ?? raw['price'];
    return v is num ? v : num.tryParse('$v') ?? 0;
  }
  String? get type => raw['type']?.toString();
  String? get method => raw['method']?.toString();
}

class IncomeCard {
  final String text;
  final num count;
  final num? percentage;
  final bool custody;

  const IncomeCard({required this.text, required this.count, this.percentage, this.custody = false});

  factory IncomeCard.fromJson(Map<String, dynamic> json) {
    num toNum(v) => v is num ? v : num.tryParse('$v') ?? 0;
    return IncomeCard(
      text: '${json['text'] ?? json['title'] ?? ''}',
      count: toNum(json['count'] ?? json['total'] ?? 0),
      percentage: json['percentage'] is num ? json['percentage'] as num : num.tryParse('${json['percentage'] ?? ''}'),
      custody: (json['custody'] == true) || (json['text']?.toString().toLowerCase().contains('custody') ?? false),
    );
  }
}

class PaymentSlipPageData {
  final List<dynamic> rows;
  final int page;
  final int totalPages;
  const PaymentSlipPageData({required this.rows, required this.page, required this.totalPages});

  factory PaymentSlipPageData.fromJson(Map<String, dynamic> json) {
    final rows = (json['rows'] as List?) ?? (json['data'] as List?) ?? const [];
    final page = json['page'] is int ? json['page'] as int : int.tryParse('${json['page'] ?? 1}') ?? 1;
    final total = json['total_pages'] is int ? json['total_pages'] as int : int.tryParse('${json['total_pages'] ?? 1}') ?? 1;
    return PaymentSlipPageData(rows: rows, page: page, totalPages: total);
  }
}
