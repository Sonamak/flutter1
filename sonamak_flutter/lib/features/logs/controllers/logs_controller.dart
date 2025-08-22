
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/logs/data/logs_models.dart';
import 'package:sonamak_flutter/features/logs/data/logs_repository.dart';

class LogsState {
  final bool loading;
  final List<LogRow> rows;
  final int page;
  final int totalPages;
  final String pageBase;
  final Object? error;

  const LogsState({required this.loading, this.rows = const [], this.page = 1, this.totalPages = 1, this.pageBase = '/logs/all-logs?page=', this.error});
  factory LogsState.initial() => const LogsState(loading: false);
}

class LogsController extends ChangeNotifier {
  LogsController(this._repo);
  final LogsRepository _repo;

  LogsState _state = LogsState.initial();
  LogsState get state => _state;

  Future<void> bootstrap() async {
    _state = const LogsState(loading: true);
    notifyListeners();
    try {
      final res = await _repo.initial();
      final totalPages = (res.total / 10).ceil();
      _state = LogsState(loading: false, rows: res.rows, page: 1, totalPages: totalPages, pageBase: res.pageBase);
      notifyListeners();
    } catch (e) {
      _state = LogsState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<void> applyRange(List<String> date) async {
    _state = LogsState(loading: true, page: 1, pageBase: state.pageBase);
    notifyListeners();
    try {
      final res = await _repo.filter(date: date);
      final totalPages = (res.total / 10).ceil();
      _state = LogsState(loading: false, rows: res.rows, page: 1, totalPages: totalPages, pageBase: res.pageBase);
      notifyListeners();
    } catch (e) {
      _state = LogsState(loading: false, error: e, pageBase: state.pageBase);
      notifyListeners();
    }
  }

  Future<void> goTo(int page) async {
    if (page < 1) return;
    _state = LogsState(loading: true, page: page, rows: state.rows, totalPages: state.totalPages, pageBase: state.pageBase);
    notifyListeners();
    try {
      final list = await _repo.page(state.pageBase, page);
      _state = LogsState(loading: false, page: page, rows: list, totalPages: state.totalPages, pageBase: state.pageBase);
      notifyListeners();
    } catch (e) {
      _state = LogsState(loading: false, page: page, error: e, totalPages: state.totalPages, pageBase: state.pageBase);
      notifyListeners();
    }
  }
}
