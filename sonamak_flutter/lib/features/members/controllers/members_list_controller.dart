
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/members/data/members_models.dart';
import 'package:sonamak_flutter/features/members/data/members_repository.dart';

class MembersListState {
  final bool loading;
  final List<MemberLite> items;
  final Object? error;
  const MembersListState({required this.loading, this.items = const [], this.error});
  factory MembersListState.initial() => const MembersListState(loading: false);
}

class MembersListController extends ChangeNotifier {
  MembersListController(this._repo);
  final MembersRepository _repo;

  MembersListState _state = MembersListState.initial();
  MembersListState get state => _state;

  Future<void> load() async {
    _state = const MembersListState(loading: true);
    notifyListeners();
    try {
      final items = await _repo.listUsers();
      _state = MembersListState(loading: false, items: items);
      notifyListeners();
    } catch (e) {
      _state = MembersListState(loading: false, error: e);
      notifyListeners();
    }
  }
}
