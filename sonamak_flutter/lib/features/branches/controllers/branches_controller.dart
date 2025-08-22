
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/branches/data/branch_models.dart';
import 'package:sonamak_flutter/features/branches/data/branches_repository.dart';

class BranchesState {
  final bool loading;
  final List<Branch> branches;
  final Object? error;
  const BranchesState({required this.loading, this.branches = const [], this.error});
  factory BranchesState.initial() => const BranchesState(loading: false);
}

class BranchesController extends ChangeNotifier {
  BranchesController(this._repo);
  final BranchesRepository _repo;

  BranchesState _state = BranchesState.initial();
  BranchesState get state => _state;

  Future<void> load() async {
    _state = const BranchesState(loading: true);
    notifyListeners();
    try {
      final list = await _repo.list();
      _state = BranchesState(loading: false, branches: list);
      notifyListeners();
    } catch (e) {
      _state = BranchesState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<bool> update(Branch b) async {
    try { await _repo.update(b); await load(); return true; } catch (_) { return false; }
  }
  Future<bool> delete(int id) async {
    try { await _repo.delete(id); await load(); return true; } catch (_) { return false; }
  }
}
