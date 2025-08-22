
import 'package:sonamak_flutter/core/security/secure_storage.dart';

class BranchPersistence {
  static const _key = 'selected_branch_id';

  static Future<void> saveBranchId(String branchId) async {
    await SecureStorage.write(_key, branchId);
  }

  static Future<String?> loadBranchId() => SecureStorage.read(_key);

  static Future<void> clear() => SecureStorage.delete(_key);
}
