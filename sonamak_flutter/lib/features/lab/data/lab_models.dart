
class LabOrderLite {
  final int id;
  final String patientName;
  final String status;
  final num? total;
  final num? paid;
  final num? rest;
  final String? createdAt;
  final String section; // analysis / scanCenter / dentistry

  const LabOrderLite({
    required this.id,
    required this.patientName,
    required this.status,
    this.total,
    this.paid,
    this.rest,
    this.createdAt,
    required this.section,
  });

  factory LabOrderLite.fromJson(Map<String, dynamic> json, {String section = 'analysis'}) {
    final id = json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0;
    final name = json['patient_name'] ?? json['name'] ?? json['patient'] ?? '';
    final status = json['status']?.toString() ?? json['active']?.toString() ?? '';
    num? toNum(v) {
      if (v is num) return v;
      return num.tryParse('$v');
    }
    return LabOrderLite(
      id: id,
      patientName: '$name',
      status: status,
      total: toNum(json['total'] ?? json['amount']),
      paid: toNum(json['paid'] ?? json['paid_up']),
      rest: toNum(json['rest'] ?? json['remaining']),
      createdAt: json['created_at']?.toString(),
      section: section,
    );
  }
}
