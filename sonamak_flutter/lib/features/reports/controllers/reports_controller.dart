
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/reports/data/reports_repository.dart';

enum ReportKind {
  examination,
  purchases,
  laboratory,
  laboratoryDentist,
  patients,
  patientsAbsent,
  procedures,
  store,
  storeExpire,
  storePayment,
}

class ReportsState {
  final bool loading;
  final ReportKind? lastRun;
  final Object? error;
  const ReportsState({required this.loading, this.lastRun, this.error});
  factory ReportsState.initial() => const ReportsState(loading: false);
}

class ReportsController extends ChangeNotifier {
  ReportsController(this._repo);
  final ReportsRepository _repo;

  ReportsState _state = ReportsState.initial();
  ReportsState get state => _state;

  Future<bool> run(ReportKind kind, Map<String, dynamic>? params) async {
    _state = ReportsState(loading: true);
    notifyListeners();
    try {
      switch (kind) {
        case ReportKind.examination: await _repo.exportExamination(params: params); break;
        case ReportKind.purchases: await _repo.exportPurchases(params: params); break;
        case ReportKind.laboratory: await _repo.exportLaboratory(params: params); break;
        case ReportKind.laboratoryDentist: await _repo.exportLaboratoryDentist(params: params); break;
        case ReportKind.patients: await _repo.exportPatients(params: params); break;
        case ReportKind.patientsAbsent: await _repo.exportPatientsAbsent(params: params); break;
        case ReportKind.procedures: await _repo.exportProcedures(params: params); break;
        case ReportKind.store: await _repo.exportStore(params: params); break;
        case ReportKind.storeExpire: await _repo.exportStoreExpire(params: params); break;
        case ReportKind.storePayment: await _repo.exportStorePayment(params: params); break;
      }
      _state = ReportsState(loading: false, lastRun: kind);
      notifyListeners();
      return true;
    } catch (e) {
      _state = ReportsState(loading: false, error: e);
      notifyListeners();
      return false;
    }
  }
}
