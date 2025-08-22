
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/patients/data/patient_models.dart';
import 'package:sonamak_flutter/features/patients/data/patient_repository.dart';

class PatientProfileState {
  final bool loading;
  final PatientProfile? profile;
  final List<Map<String, dynamic>> examinations;
  final Object? error;
  const PatientProfileState({required this.loading, this.profile, this.examinations = const [], this.error});
  factory PatientProfileState.initial() => const PatientProfileState(loading: false);
}

class PatientProfileController extends ChangeNotifier {
  PatientProfileController(this._repo);
  final PatientRepository _repo;

  PatientProfileState _state = PatientProfileState.initial();
  PatientProfileState get state => _state;

  Future<void> load(int id) async {
    _state = const PatientProfileState(loading: true);
    notifyListeners();
    try {
      final p = await _repo.getProfile(id);
      final ex = await _repo.examinations(id);
      _state = PatientProfileState(loading: false, profile: p, examinations: ex);
      notifyListeners();
    } catch (e) {
      _state = PatientProfileState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    _state = PatientProfileState(loading: true, profile: _state.profile, examinations: _state.examinations);
    notifyListeners();
    try {
      final p = await _repo.update(data);
      _state = PatientProfileState(loading: false, profile: p, examinations: _state.examinations);
      notifyListeners();
    } catch (e) {
      _state = PatientProfileState(loading: false, error: e, examinations: _state.examinations);
      notifyListeners();
    }
  }
}
