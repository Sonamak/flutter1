
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/lab/data/lab_api.dart';
import 'package:sonamak_flutter/features/lab/data/lab_models.dart';
import 'package:sonamak_flutter/features/lab/data/lab_repository.dart';

class LabState {
  final bool loading;
  final LabSection section;
  final List<LabOrderLite> items;
  final String? error;
  final String? query;
  final String? from;
  final String? to;
  final int? branchId;

  const LabState({
    required this.loading,
    required this.section,
    this.items = const [],
    this.error,
    this.query,
    this.from,
    this.to,
    this.branchId,
  });

  factory LabState.initial() => const LabState(loading: false, section: LabSection.analysis);

  LabState copyWith({
    bool? loading,
    LabSection? section,
    List<LabOrderLite>? items,
    String? error,
    String? query,
    String? from,
    String? to,
    int? branchId,
  }) {
    return LabState(
      loading: loading ?? this.loading,
      section: section ?? this.section,
      items: items ?? this.items,
      error: error,
      query: query ?? this.query,
      from: from ?? this.from,
      to: to ?? this.to,
      branchId: branchId ?? this.branchId,
    );
  }
}

class LabController extends ChangeNotifier {
  LabController(this._repo);
  final LabRepository _repo;

  LabState _state = LabState.initial();
  LabState get state => _state;

  Future<void> bootstrap() async {
    _state = _state.copyWith(loading: true, error: null);
    notifyListeners();
    try {
      final list = await _repo.initial();
      _state = _state.copyWith(loading: false, items: list);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loading: false, error: e.toString());
      notifyListeners();
    }
  }

  Future<void> setSection(LabSection section) async {
    _state = _state.copyWith(section: section);
    notifyListeners();
    await refresh();
  }

  Future<void> setFilters({String? q, String? from, String? to, int? branchId}) async {
    _state = _state.copyWith(query: q, from: from, to: to, branchId: branchId);
    notifyListeners();
    await refresh();
  }

  Future<void> refresh() async {
    _state = _state.copyWith(loading: true, error: null);
    notifyListeners();
    try {
      final list = await _repo.fetch(
        section: _state.section,
        q: _state.query,
        from: _state.from,
        to: _state.to,
        branchId: _state.branchId,
      );
      _state = _state.copyWith(loading: false, items: list);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loading: false, error: e.toString());
      notifyListeners();
    }
  }

  Future<bool> pay({required int id, required num amount}) async {
    try {
      await _repo.savePaidUp(id: id, amount: amount);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> payOff(int id) async {
    try {
      await _repo.payOff(id: id);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleActive({required int id, required bool active}) async {
    try {
      await _repo.activate(id: id, active: active);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> exportExcel() async {
    try {
      await _repo.exportExcel(section: _state.section);
      return true;
    } catch (_) {
      return false;
    }
  }
}
