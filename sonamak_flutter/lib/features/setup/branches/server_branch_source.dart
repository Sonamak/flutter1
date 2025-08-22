import 'package:sonamak_flutter/features/setup/branches/branch_selector.dart' as sel;
import 'package:sonamak_flutter/features/branches/data/branches_repository.dart';
import 'package:sonamak_flutter/features/branches/data/branch_models.dart' as model;

/// Server-backed BranchDataSource adapter.
class ServerBranchSource implements sel.BranchDataSource {
  final _repo = BranchesRepository();
  @override
  Future<List<sel.Branch>> listBranches() async {
    final List<model.Branch> raw = await _repo.list();
    return raw.map((b) => sel.Branch(id: b.id.toString(), name: b.name)).toList(growable: false);
  }
}
