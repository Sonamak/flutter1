
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/clinics/data/clinics_models.dart';
import 'package:sonamak_flutter/features/clinics/data/clinics_repository.dart';

class ClinicsState {
  final bool loading;
  final List<Clinic> clinics;
  final Clinic? selected;
  final Object? error;

  const ClinicsState({required this.loading, this.clinics = const [], this.selected, this.error});
  factory ClinicsState.initial() => const ClinicsState(loading: false);
}

class ClinicsController extends ChangeNotifier {
  ClinicsController(this._repo);
  final ClinicsRepository _repo;

  ClinicsState _state = ClinicsState.initial();
  ClinicsState get state => _state;

  Future<void> load() async {
    _state = const ClinicsState(loading: true);
    notifyListeners();
    try {
      final list = await _repo.list();
      _state = ClinicsState(loading: false, clinics: list, selected: list.isNotEmpty ? list.first : null);
      notifyListeners();
    } catch (e) {
      _state = ClinicsState(loading: false, error: e);
      notifyListeners();
    }
  }

  void select(Clinic? c) {
    _state = ClinicsState(loading: false, clinics: state.clinics, selected: c);
    notifyListeners();
  }

  Future<bool> addClinic(Map<String, dynamic> payload) async {
    try {
      final c = await _repo.handle(payload);
      if (c != null) {
        final updated = [...state.clinics, c];
        _state = ClinicsState(loading: false, clinics: updated, selected: c);
        notifyListeners();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleSuspend() async {
    final sel = state.selected;
    if (sel == null) return false;
    try {
      await _repo.changeSuspend(clinicId: sel.id, active: !sel.active);
      // refresh locally
      final repl = Clinic(
        id: sel.id, name: sel.name, email: sel.email, phone: sel.phone, subdomain: sel.subdomain, currencyId: sel.currencyId,
        active: !sel.active, status: sel.status, subscriptions: sel.subscriptions, raw: sel.raw
      );
      final list = state.clinics.map((e) => e.id == sel.id ? repl : e).toList(growable: false);
      _state = ClinicsState(loading: false, clinics: list, selected: repl);
      notifyListeners();
      return true;
    } catch (_) { return false; }
  }

  Future<bool> addExtras(int clinicId, List<Map<String, dynamic>> extras) async {
    try { await _repo.addExtras(clinicId: clinicId, extras: extras); return true; } catch (_) { return false; }
  }

  Future<bool> updateSubscription(Subscription s) async {
    try { await _repo.updateSubscription(s); return true; } catch (_) { return false; }
  }
}
