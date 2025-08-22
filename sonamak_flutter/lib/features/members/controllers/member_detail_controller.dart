
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/members/data/members_models.dart';
import 'package:sonamak_flutter/features/members/data/members_repository.dart';

class MemberDetailState {
  final bool loading;
  final MemberDetail? detail;
  final Object? error;
  const MemberDetailState({required this.loading, this.detail, this.error});
  factory MemberDetailState.initial() => const MemberDetailState(loading: false);
}

class MemberDetailController extends ChangeNotifier {
  MemberDetailController(this._repo);
  final MembersRepository _repo;

  MemberDetailState _state = MemberDetailState.initial();
  MemberDetailState get state => _state;

  Future<void> load(int id) async {
    _state = const MemberDetailState(loading: true);
    notifyListeners();
    try {
      final d = await _repo.getUser(id);
      _state = MemberDetailState(loading: false, detail: d);
      notifyListeners();
    } catch (e) {
      _state = MemberDetailState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<bool> update({String? role, List<int>? permissions}) async {
    final id = _state.detail?.id;
    if (id == null) return false;
    final ok = await _repo.updateUser(id: id, role: role, permissions: permissions);
    if (ok) {
      await load(id);
    }
    return ok;
  }
}
