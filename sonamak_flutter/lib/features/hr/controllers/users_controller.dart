
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/hr/data/hr_models.dart';
import 'package:sonamak_flutter/features/hr/data/hr_repository.dart';

class UsersState {
  final bool loading;
  final List<UserLite> users;
  final Map<String, dynamic>? detail;
  final Object? error;

  const UsersState({required this.loading, this.users = const [], this.detail, this.error});
  factory UsersState.initial() => const UsersState(loading: false);
}

class UsersController extends ChangeNotifier {
  UsersController(this._repo);
  final HrRepository _repo;

  UsersState _state = UsersState.initial();
  UsersState get state => _state;

  Future<void> load() async {
    _state = const UsersState(loading: true);
    notifyListeners();
    try {
      final list = await _repo.users();
      _state = UsersState(loading: false, users: list);
      notifyListeners();
    } catch (e) {
      _state = UsersState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<void> openDetail(int id) async {
    _state = UsersState(loading: true, users: _state.users);
    notifyListeners();
    try {
      final data = await _repo.userData(id);
      _state = UsersState(loading: false, users: _state.users, detail: data);
      notifyListeners();
    } catch (e) {
      _state = UsersState(loading: false, users: _state.users, error: e);
      notifyListeners();
    }
  }

  Future<bool> update(Map<String, dynamic> data) async {
    try {
      await _repo.updateUser(data);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> remove(int id) async {
    try {
      await _repo.deleteUser(id);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resetPassword(Map<String, dynamic> data) async {
    try {
      await _repo.resetUserPassword(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> exportExcel() async {
    try {
      await _repo.usersExcel();
      return true;
    } catch (_) {
      return false;
    }
  }
}
