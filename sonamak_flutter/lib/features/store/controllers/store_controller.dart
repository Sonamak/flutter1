
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/store/data/store_models.dart';
import 'package:sonamak_flutter/features/store/data/store_repository.dart';

class StoreState {
  final bool loading;
  final List<SubStore> subStores;
  final int? selectedSubStoreId;
  final List<StoreProductLite> products;
  final String? search;
  final String? error;

  const StoreState({
    required this.loading,
    this.subStores = const [],
    this.selectedSubStoreId,
    this.products = const [],
    this.search,
    this.error,
  });

  factory StoreState.initial() => const StoreState(loading: false);

  StoreState copyWith({
    bool? loading,
    List<SubStore>? subStores,
    int? selectedSubStoreId,
    List<StoreProductLite>? products,
    String? search,
    String? error,
  }) {
    return StoreState(
      loading: loading ?? this.loading,
      subStores: subStores ?? this.subStores,
      selectedSubStoreId: selectedSubStoreId ?? this.selectedSubStoreId,
      products: products ?? this.products,
      search: search ?? this.search,
      error: error,
    );
  }
}

class StoreController extends ChangeNotifier {
  StoreController(this._repo);
  final StoreRepository _repo;

  StoreState _state = StoreState.initial();
  StoreState get state => _state;

  Future<void> bootstrap() async {
    _state = _state.copyWith(loading: true, error: null);
    notifyListeners();
    try {
      final tabs = await _repo.getSubStores();
      final sel = tabs.isNotEmpty ? tabs.first.id : null;
      List<StoreProductLite> items = const [];
      if (sel != null) {
        items = await _repo.getProducts({'sub_store_id': sel});
      } else {
        items = await _repo.getProducts(null);
      }
      _state = _state.copyWith(loading: false, subStores: tabs, selectedSubStoreId: sel, products: items);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loading: false, error: e.toString());
      notifyListeners();
    }
  }

  Future<void> selectSubStore(int? id) async {
    _state = _state.copyWith(selectedSubStoreId: id);
    notifyListeners();
    await refresh();
  }

  Future<void> setSearch(String q) async {
    _state = _state.copyWith(search: q);
    notifyListeners();
    await refresh();
  }

  Future<void> refresh() async {
    final params = <String, dynamic>{};
    if (_state.selectedSubStoreId != null) params['sub_store_id'] = _state.selectedSubStoreId;
    if ((_state.search ?? '').isNotEmpty) params['search'] = _state.search;
    _state = _state.copyWith(loading: true);
    notifyListeners();
    try {
      final items = await _repo.getProducts(params.isEmpty ? null : params);
      _state = _state.copyWith(loading: false, products: items);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loading: false, error: e.toString());
      notifyListeners();
    }
  }

  Future<bool> addOrEditProduct(Map<String, dynamic> data) async {
    try {
      await _repo.insertProduct(data);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}
