import 'package:sonamak_flutter/features/members/data/members_api.dart';
import 'package:sonamak_flutter/features/members/data/members_models.dart';

class MembersRepository {
  Future<List<MemberLite>> listUsers() async {
    final res = await MembersApi.listUsers();
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(MemberLite.fromJson).toList(growable: false);
  }

  Future<MemberDetail?> getUser(int id) async {
    final res = await MembersApi.getUser(id);
    final map = (res.data ?? const {});
    if (map.isEmpty) return null;
    return MemberDetail.fromJson(map);
  }

  /// Accepts named arguments OR a `data` map.
  Future<bool> updateUser({
    int? id,
    String? role,
    List<int>? permissions,
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? data,
  }) async {
    final payload = <String, dynamic>{
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (permissions != null) 'permissions': permissions,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      ...?data,
    };
    await MembersApi.updateUser(payload);
    return true;
  }

  Future<void> removeUser(int id) async {
    await MembersApi.removeUser(id);
  }
}
