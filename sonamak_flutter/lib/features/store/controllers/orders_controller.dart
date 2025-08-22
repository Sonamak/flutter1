import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/store/data/store_models.dart';
import 'package:sonamak_flutter/features/store/data/store_repository.dart';

class OrdersController extends ChangeNotifier {
  final StoreRepository _repo = StoreRepository();

  List<OrderRow> rows = const [];
  bool loading = false;

  String get state => loading ? 'loading' : 'idle'; // ✅ for legacy UIs

  Future<void> load([dynamic filter]) async {
    loading = true;
    notifyListeners();
    final list = await _repo.getOrdersCards(filter); // returns List<Map<String,dynamic>>
    rows = list.whereType<Map<String, dynamic>>().map(OrderRow.fromJson).toList(growable: false);
    loading = false;
    notifyListeners();
  }

  Future<void> changeStatus(int id, String status) async {
    await _repo.changeOrderStatus({'id': id, 'status': status});
    await load();
  }

  Future<void> changeRefund(int id, String status) async {
    await _repo.changeRefundStatus({'id': id, 'status': status});
    await load();
  }

  // ✅ Aliases expected by older pages
  Future<void> setStatus(int id, String status) => changeStatus(id, status);
  Future<void> setRefund(int id, String status) => changeRefund(id, status);
}
