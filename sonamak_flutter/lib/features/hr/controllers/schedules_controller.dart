
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/hr/data/hr_models.dart';
import 'package:sonamak_flutter/features/hr/data/hr_repository.dart';

class SchedulesState {
  final bool loading;
  final List<ScheduleItem> items;
  final String? date;
  final Object? error;

  const SchedulesState({required this.loading, this.items = const [], this.date, this.error});
  factory SchedulesState.initial() => const SchedulesState(loading: false);
}

class SchedulesController extends ChangeNotifier {
  SchedulesController(this._repo);
  final HrRepository _repo;

  SchedulesState _state = SchedulesState.initial();
  SchedulesState get state => _state;

  Future<void> load({String? date}) async {
    _state = SchedulesState(loading: true, date: date);
    notifyListeners();
    try {
      final items = await _repo.appointments(params: {'date': date});
      _state = SchedulesState(loading: false, date: date, items: items);
      notifyListeners();
    } catch (e) {
      _state = SchedulesState(loading: false, date: date, error: e);
      notifyListeners();
    }
  }

  Future<bool> confirm(int id, {int status = 1}) async {
    try {
      await _repo.confirmSchedule({'id': id, 'status': status});
      await load(date: _state.date);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> exportExcel({bool online = false}) async {
    try {
      await _repo.schedulesExcel(online: online, params: {'date': _state.date});
      return true;
    } catch (_) {
      return false;
    }
  }
}
