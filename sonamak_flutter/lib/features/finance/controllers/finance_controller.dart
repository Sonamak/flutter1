
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/finance/data/finance_models.dart';
import 'package:sonamak_flutter/features/finance/data/finance_repository.dart';

class FinanceState {
  final bool loading;
  final List<FinanceRow> rows;
  final List<IncomeCard>? incomes;
  final List<BranchItem> branches;
  final int? branchId;
  final String? filter;
  final String? date;
  final String? event;
  final int? isVisa;
  final int? visit;
  final Object? error;

  const FinanceState({
    required this.loading,
    this.rows = const [],
    this.incomes,
    this.branches = const [],
    this.branchId,
    this.filter,
    this.date,
    this.event,
    this.isVisa,
    this.visit,
    this.error,
  });

  factory FinanceState.initial() => const FinanceState(loading: false);
}

class FinanceController extends ChangeNotifier {
  FinanceController(this._repo);
  final FinanceRepository _repo;

  FinanceState _state = FinanceState.initial();
  FinanceState get state => _state;

  Future<void> bootstrap() async {
    _state = const FinanceState(loading: true);
    notifyListeners();
    try {
      final bs = await _repo.branches();
      final (tx, incomes) = await _repo.allTransactions();
      _state = FinanceState(loading: false, rows: tx, incomes: incomes, branches: bs);
      notifyListeners();
    } catch (e) {
      _state = FinanceState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<void> setFilters({
    String? event, String? date, String? filter, int? branchId, int? isVisa, int? visit,
  }) async {
    _state = FinanceState(
      loading: true,
      branches: _state.branches,
      event: event ?? _state.event,
      date: date ?? _state.date,
      filter: filter ?? _state.filter,
      branchId: branchId ?? _state.branchId,
      isVisa: isVisa ?? _state.isVisa,
      visit: visit ?? _state.visit,
      incomes: _state.incomes,
    );
    notifyListeners();
    try {
      final (tx, incomes) = await _repo.search(
        event: _state.event, date: _state.date, filter: _state.filter, branchId: _state.branchId, isVisa: _state.isVisa, visit: _state.visit,
      );
      _state = FinanceState(
        loading: false,
        rows: tx,
        incomes: incomes,
        branches: _state.branches,
        event: _state.event, date: _state.date, filter: _state.filter, branchId: _state.branchId, isVisa: _state.isVisa, visit: _state.visit,
      );
      notifyListeners();
    } catch (e) {
      _state = FinanceState(loading: false, branches: _state.branches, error: e);
      notifyListeners();
    }
  }

  Future<bool> addCustody(num amount) async {
    final bid = _state.branchId;
    if (bid == null) return false;
    try {
      await _repo.saveCustody(amount: amount, branchId: bid);
      await setFilters();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> downloadExcel() async {
    try {
      await _repo.downloadExcel({
        if (_state.event != null) 'event': _state.event,
        if (_state.date != null) 'date': _state.date,
        if (_state.filter != null) 'filter': _state.filter,
        if (_state.branchId != null) 'branchId': _state.branchId,
        if (_state.isVisa != null) 'is_visa': _state.isVisa,
        if (_state.visit != null) 'visit': _state.visit,
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
