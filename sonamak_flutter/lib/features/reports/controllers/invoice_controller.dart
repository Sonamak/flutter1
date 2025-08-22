
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/reports/data/reports_repository.dart';

class InvoiceState {
  final bool loading;
  final Map<String, dynamic>? data;
  final Object? error;
  const InvoiceState({required this.loading, this.data, this.error});
  factory InvoiceState.initial() => const InvoiceState(loading: false);
}

class InvoiceController extends ChangeNotifier {
  InvoiceController(this._repo);
  final ReportsRepository _repo;

  InvoiceState _state = InvoiceState.initial();
  InvoiceState get state => _state;

  Future<void> load({required dynamic id, required dynamic patientId, String? createdAt, dynamic invoice}) async {
    _state = const InvoiceState(loading: true);
    notifyListeners();
    try {
      final res = await _repo.invoiceData(id: id, patientId: patientId, createdAt: createdAt, invoice: invoice);
      _state = InvoiceState(loading: false, data: res);
      notifyListeners();
    } catch (e) {
      _state = InvoiceState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<bool> editPrice(Map<String, dynamic> payload) async {
    try {
      await _repo.editInvoicePrice(payload);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> billing(Map<String, dynamic> payload) => _repo.billingInvoice(payload);

  Future<bool> printExamination({Map<String, dynamic>? params}) async {
    try {
      await _repo.examinationInvoice(params: params);
      return true;
    } catch (_) {
      return false;
    }
  }
}
