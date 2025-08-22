
import 'package:sonamak_flutter/features/branches/data/branch_models.dart';
import 'package:sonamak_flutter/features/branches/data/branches_api.dart';

class BranchesRepository {
  Future<List<Branch>> list() async {
    final res = await BranchesApi.getBranches();
    final list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map((e) => Branch.fromJson(e)).toList(growable: false);
  }

  Future<void> update(Branch b) => BranchesApi.branchUpdate(b.toUpdatePayload());
  Future<void> delete(int id) => BranchesApi.deleteBranch(id);
}
