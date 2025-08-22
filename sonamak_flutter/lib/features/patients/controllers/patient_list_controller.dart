
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/patients/data/patient_models.dart';
import 'package:sonamak_flutter/features/patients/data/patient_repository.dart';

class PatientListState {
  final bool loading;
  final List<PatientLite> items;
  final Object? error;
  const PatientListState({required this.loading, this.items = const [], this.error});
  factory PatientListState.initial() => const PatientListState(loading: false);
}

class PatientListController extends ChangeNotifier {
  PatientListController(this._repo);
  final PatientRepository _repo;

  PatientListState _state = PatientListState.initial();
  PatientListState get state => _state;

  Future<void> load({int? branchId}) async {
    _state = const PatientListState(loading: true);
    notifyListeners();
    try {
      final items = await _repo.listAll(branchId: branchId);
      _state = PatientListState(loading: false, items: items);
      notifyListeners();
    } catch (e) {
      _state = PatientListState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<void> search(String term, {int? branchId}) async {
    _state = const PatientListState(loading: true);
    notifyListeners();
    try {
      final items = await _repo.searchBy(term, branchId: branchId);
      _state = PatientListState(loading: false, items: items);
      notifyListeners();
    } catch (e) {
      _state = PatientListState(loading: false, error: e);
      notifyListeners();
    }
  }
}
