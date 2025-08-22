import 'package:sonamak_flutter/features/store/data/store_api.dart';
import 'package:sonamak_flutter/features/store/data/store_models.dart';

class StoreRepository {
  /// Return raw map list to satisfy controllers expecting `List<Map<String,dynamic>>`.
  Future<List<Map<String, dynamic>>> getOrdersCards([dynamic filter]) async {
    final res = await StoreApi.getOrdersCards(filter);
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().toList(growable: false);
  }

  Future<Map<String, dynamic>> getOrderData(dynamic idOrPayload) async {
    final int id = idOrPayload is int ? idOrPayload : int.tryParse('${(idOrPayload as Map)['id']}') ?? 0;
    final res = await StoreApi.getOrderData(id);
    return (res.data ?? const {});
  }

  Future<void> changeOrderStatus(dynamic idOrPayload, [String? status]) async {
    if (idOrPayload is Map) {
      final int id = idOrPayload['id'] is int ? idOrPayload['id'] as int : int.tryParse('${idOrPayload['id']}') ?? 0;
      final String st = (idOrPayload['status'] ?? status ?? '').toString();
      await StoreApi.changeOrderStatus(id, st);
    } else {
      await StoreApi.changeOrderStatus(idOrPayload as int, status ?? '');
    }
  }

  Future<void> changeRefundStatus(dynamic idOrPayload, [String? status]) async {
    if (idOrPayload is Map) {
      final int id = idOrPayload['id'] is int ? idOrPayload['id'] as int : int.tryParse('${idOrPayload['id']}') ?? 0;
      final String st = (idOrPayload['status'] ?? status ?? '').toString();
      await StoreApi.changeRefundStatus(id, st);
    } else {
      await StoreApi.changeRefundStatus(idOrPayload as int, status ?? '');
    }
  }

  Future<List<SubStore>> getSubStores() async {
    final res = await StoreApi.getSubStores();
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(SubStore.fromJson).toList(growable: false);
  }

  Future<List<StoreProductLite>> getProducts([dynamic q]) async {
    final res = await StoreApi.getProducts(q is Map<String, dynamic> ? q : {'store': q});
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(StoreProductLite.fromJson).toList(growable: false);
  }

  Future<void> insertProduct(Map<String, dynamic> product) async { await StoreApi.insertProduct(product); }
}
