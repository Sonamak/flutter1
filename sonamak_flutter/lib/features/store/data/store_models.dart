class OrderRow {
  final int id;
  final String? status;

  // extra fields used by UI
  final String? item;
  final String? patient;
  final int? quantity;

  const OrderRow({required this.id, this.status, this.item, this.patient, this.quantity});

  factory OrderRow.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    int? toIntOrNull(v) => v == null ? null : (v is int ? v : int.tryParse('$v'));
    return OrderRow(
      id: toInt(json['id']),
      status: (json['status'] ?? '').toString(),
      item: (json['item'] ?? json['product'] ?? json['name'] ?? '').toString(),
      patient: (json['patient'] ?? json['customer'] ?? '').toString(),
      quantity: toIntOrNull(json['quantity']),
    );
  }
}

class StoreProductLite {
  final int id;
  final String name;

  // extra fields used by UI
  final int? quantity;
  final int? criticalQuantity;
  final String? expireDate;

  const StoreProductLite({
    required this.id,
    required this.name,
    this.quantity,
    this.criticalQuantity,
    this.expireDate,
  });

  factory StoreProductLite.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    int? toIntOrNull(v) => v == null ? null : (v is int ? v : int.tryParse('$v'));
    return StoreProductLite(
      id: toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      quantity: toIntOrNull(json['quantity']),
      criticalQuantity: toIntOrNull(json['criticalQuantity'] ?? json['critical_quantity']),
      expireDate: (json['expireDate'] ?? json['expire_date'] ?? '').toString(),
    );
  }
}

class SubStore {
  final int id;
  final String name;
  const SubStore({required this.id, required this.name});
  factory SubStore.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return SubStore(id: toInt(json['id']), name: (json['name'] ?? '').toString());
  }
}
