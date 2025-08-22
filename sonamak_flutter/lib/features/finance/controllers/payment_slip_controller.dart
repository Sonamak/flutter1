
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/finance/data/finance_models.dart';
import 'package:sonamak_flutter/features/finance/data/finance_repository.dart';

class PaymentSlipState {
  final bool loading;
  final PaymentSlipPageData? page;
  final int pageIndex;
  final String? event;
  final String? date;
  final dynamic filter;
  final int? branchId;
  final Object? error;
  const PaymentSlipState({
    required this.loading,
    this.page,
    this.pageIndex = 1,
    this.event,
    this.date,
    this.filter,
    this.branchId,
    this.error,
  });
  factory PaymentSlipState.initial() => const PaymentSlipState(loading: false, pageIndex: 1);
}

class PaymentSlipController extends ChangeNotifier {
  PaymentSlipController(this._repo, {required this.userId});
  final FinanceRepository _repo;
  final int userId;

  PaymentSlipState _state = PaymentSlipState.initial();
  PaymentSlipState get state => _state;

  Future<void> load({int page = 1}) async {
    _state = PaymentSlipState(loading: true, pageIndex: page, event: _state.event, date: _state.date, filter: _state.filter, branchId: _state.branchId);
    notifyListeners();
    try {
      final res = await _repo.paymentSlip(userId: userId, page: page, filter: _state.filter is Map<String, dynamic> ? _state.filter : null);
      _state = PaymentSlipState(loading: false, pageIndex: page, page: res, event: _state.event, date: _state.date, filter: _state.filter, branchId: _state.branchId);
      notifyListeners();
    } catch (e) {
      _state = PaymentSlipState(loading: false, pageIndex: page, error: e);
      notifyListeners();
    }
  }

  Future<void> apply({String? event, String? date, dynamic filter, int? branchId}) async {
    _state = PaymentSlipState(loading: true, pageIndex: 1, event: event, date: date, filter: filter, branchId: branchId);
    notifyListeners();
    try {
      final res = await _repo.searchSlip(userId: userId, page: 1, event: event, date: date, filter: filter, branchId: branchId);
      _state = PaymentSlipState(loading: false, pageIndex: 1, page: res, event: event, date: date, filter: filter, branchId: branchId);
      notifyListeners();
    } catch (e) {
      _state = PaymentSlipState(loading: false, pageIndex: 1, error: e);
      notifyListeners();
    }
  }
}
