
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/insurance/data/insurance_models.dart';
import 'package:sonamak_flutter/features/insurance/data/insurance_repository.dart';

class InsuranceCompaniesState {
  final bool loading;
  final List<InsuranceCompany> companies;
  final InsuranceCompany? active;
  final List<InsuranceSegment> segments;
  final List<PaymentRow> paid;
  final List<PaymentRow> required;
  final Object? error;

  const InsuranceCompaniesState({
    required this.loading,
    this.companies = const [],
    this.active,
    this.segments = const [],
    this.paid = const [],
    this.required = const [],
    this.error,
  });

  factory InsuranceCompaniesState.initial() => const InsuranceCompaniesState(loading: false);
}

class InsuranceCompaniesController extends ChangeNotifier {
  InsuranceCompaniesController(this._repo);
  final InsuranceRepository _repo;

  InsuranceCompaniesState _state = InsuranceCompaniesState.initial();
  InsuranceCompaniesState get state => _state;

  Future<void> bootstrap() async {
    _state = const InsuranceCompaniesState(loading: true);
    notifyListeners();
    try {
      final list = await _repo.listInsurances(type: 1);
      InsuranceCompany? active = list.isNotEmpty ? list.first : null;
      List<InsuranceSegment> segs = const [];
      List<PaymentRow> paid = const [];
      List<PaymentRow> req = const [];
      if (active != null) {
        segs = await _repo.segments(active.id);
        paid = await _repo.payments(active.id, 1);
        req = await _repo.payments(active.id, 2);
      }
      _state = InsuranceCompaniesState(loading: false, companies: list, active: active, segments: segs, paid: paid, required: req);
      notifyListeners();
    } catch (e) {
      _state = InsuranceCompaniesState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<void> select(int id) async {
    final active = _state.companies.firstWhere((c) => c.id == id, orElse: () => _state.companies.first);
    _state = InsuranceCompaniesState(
      loading: true,
      companies: _state.companies,
      active: active,
      segments: _state.segments,
      paid: _state.paid,
      required: _state.required,
    );
    notifyListeners();
    try {
      final segs = await _repo.segments(id);
      final paid = await _repo.payments(id, 1);
      final req = await _repo.payments(id, 2);
      _state = InsuranceCompaniesState(loading: false, companies: _state.companies, active: active, segments: segs, paid: paid, required: req);
      notifyListeners();
    } catch (e) {
      _state = InsuranceCompaniesState(loading: false, companies: _state.companies, active: active, segments: const [], paid: const [], required: const [], error: e);
      notifyListeners();
    }
  }

  Future<bool> createCompany(Map<String, dynamic> data) async {
    try {
      await _repo.createInsurance(data);
      await bootstrap();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateCompany(Map<String, dynamic> data) async {
    try {
      await _repo.updateInsurance(data);
      await select(_state.active?.id ?? -1);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteCompany(int id) async {
    try {
      await _repo.deleteInsurance(id);
      await bootstrap();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addSegment(Map<String, dynamic> data) async {
    try {
      await _repo.addSegment(data);
      if (_state.active != null) await select(_state.active!.id);
      return true;
    } catch (_) {
      return false;
    }
  }
}
