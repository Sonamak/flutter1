import 'package:sonamak_flutter/features/hr/data/hr_api.dart';
import 'package:sonamak_flutter/features/hr/data/hr_models.dart';

class HrRepository {
  // Permissions / roles
  Future<List<PermissionNode>> permissionTree(dynamic roleId) async {
    final int id = roleId is int ? roleId : int.tryParse('$roleId') ?? 0;
    final res = await HrApi.permission(id);
    final list = res.data is List ? res.data as List : (res.data?['payload'] as List? ?? const []);
    return list.whereType<Map<String, dynamic>>().map(PermissionNode.fromJson).toList(growable: false);
  }

  Future<void> roleCreate(dynamic nameOrPayload) async {
    if (nameOrPayload is Map) {
      final v = nameOrPayload['role']?.toString() ?? '';
      await HrApi.roleCreate(v);
    } else {
      await HrApi.roleCreate(nameOrPayload.toString());
    }
  }

  /// Accepts either (roleId, permissions) or a single payload map {role, permissions}
  Future<void> roleUpdate(dynamic roleOrPayload, [List<int>? permissions]) async {
    if (roleOrPayload is Map) {
      final r = roleOrPayload['role'];
      final p = (roleOrPayload['permissions'] as List?)?.map((e) => e is int ? e : int.tryParse('$e') ?? 0).toList() ?? const <int>[];
      await HrApi.roleUpdate((r is int) ? r : int.tryParse('$r') ?? 0, p);
    } else {
      await HrApi.roleUpdate((roleOrPayload is int) ? roleOrPayload : int.tryParse('$roleOrPayload') ?? 0, permissions ?? const <int>[]);
    }
  }

  // Schedules
  Future<List<ScheduleItem>> appointments({Map<String, dynamic>? params, DateTime? from, DateTime? to, int? doctorId, int? branchId}) async {
    final q = <String, dynamic>{};
    if (params != null) q.addAll(params);
    if (from != null) q['from'] = from.toIso8601String();
    if (to != null) q['to'] = to.toIso8601String();
    if (doctorId != null) q['doctor'] = doctorId;
    if (branchId != null) q['branch'] = branchId;
    final res = await HrApi.appointments(q);
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(ScheduleItem.fromJson).toList(growable: false);
  }

  Future<void> confirmSchedule(Map<String, dynamic> data) async { await HrApi.confirmSchedule(data); }

  Future<void> schedulesExcel({bool? online, Map<String, dynamic>? params, DateTime? from, DateTime? to}) async {
    final q = <String, dynamic>{};
    if (params != null) q.addAll(params);
    if (from != null) q['from'] = from.toIso8601String();
    if (to != null) q['to'] = to.toIso8601String();
    if (online != null) q['online'] = online;
    await HrApi.schedulesExcel(q);
  }

  // Users
  Future<List<UserLite>> users() async {
    final res = await HrApi.users();
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(UserLite.fromJson).toList(growable: false);
  }

  Future<Map<String, dynamic>> userData(int id) async {
    final res = await HrApi.userData(id);
    return (res.data ?? const {});
  }

  Future<void> updateUser(Map<String, dynamic> data) async { await HrApi.updateUser(data); }

  Future<void> deleteUser(dynamic idOrPayload) async {
    final int id = idOrPayload is int ? idOrPayload : int.tryParse('${(idOrPayload as Map)['id']}') ?? 0;
    await HrApi.deleteUser(id);
  }

  Future<void> resetUserPassword(dynamic idOrPayload) async {
    final int id = idOrPayload is int ? idOrPayload : int.tryParse('${(idOrPayload as Map)['id']}') ?? 0;
    await HrApi.resetUserPassword(id);
  }

  Future<void> usersExcel() async { await HrApi.usersExcel(const {}); }

  Future<List<UserLite>> usersWorkBranch(int branchId) async {
    final res = await HrApi.usersWorkBranch(branchId);
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(UserLite.fromJson).toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> usersProceduresPercentage(int branchId) async {
    final res = await HrApi.usersProceduresPercentage(branchId);
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().toList(growable: false);
  }
}
