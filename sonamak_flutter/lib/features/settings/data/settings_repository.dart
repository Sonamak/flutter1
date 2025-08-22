import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/features/settings/data/settings_api.dart';
import 'package:sonamak_flutter/features/settings/data/settings_models.dart';

class SettingsRepository {
  Future<List<RoleItem>> listRoles() async {
    final res = await HttpClient.I
        .get<List<dynamic>>('/roles/roles')
        .catchError((_) => Response<List<dynamic>>(
      requestOptions: RequestOptions(path: '/roles/roles'),
      data: const [],
    ));
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(RoleItem.fromJson).toList(growable: false);
  }

  Future<List<PermissionSetting>> loadPermissions(dynamic roleId) async {
    final id = roleId is int ? roleId : int.tryParse('$roleId') ?? 0;
    final res = await SettingsApi.permission(id);
    final list = res.data is List ? res.data as List : (res.data?['payload'] as List? ?? const []);
    return list.whereType<Map<String, dynamic>>().map(PermissionSetting.fromJson).toList(growable: false);
  }

  Future<void> updateRole(dynamic roleId, List<int> permissions) async {
    final id = roleId is int ? roleId : int.tryParse('$roleId') ?? 0;
    await SettingsApi.roleUpdate({'role': id, 'permissions': permissions});
  }

  Future<void> createRole(dynamic name) async {
    await SettingsApi.roleCreate({'role': name.toString()});
  }

  Future<Map<String, dynamic>> profileInformation() async {
    final res = await SettingsApi.profileInformation();
    return (res.data ?? const {}) as Map<String, dynamic>;
  }

  // -------- FIXED SIGNATURE (named params) --------
  Future<void> profileSettingsUpdate({
    Map<String, dynamic>? data,
    dynamic images, // allow any image payload shape used by controller
    FormData? form,
  }) async {
    final payload = <String, dynamic>{...?data};
    if (images != null) payload['images'] = images;
    final f = form ?? FormData.fromMap(payload);
    await SettingsApi.profileSettingsUpdate(f);
  }

  Future<Map<String, dynamic>> clinicSettings() async {
    final res = await SettingsApi.clinicSettings();
    return (res.data ?? const {}) as Map<String, dynamic>;
  }

  // -------- FIXED SIGNATURE (named params) --------
  Future<void> clinicSettingsUpdate({
    dynamic smsGroups,     // controller may send List<String> or List<Map>
    dynamic workingHours,  // controller may send List<Map> or other shape
    Map<String, dynamic>? data,
    FormData? form,
  }) async {
    final payload = <String, dynamic>{...?data};
    if (smsGroups != null) payload['sms_groups'] = smsGroups;
    if (workingHours != null) payload['working_hours'] = workingHours;
    final f = form ?? FormData.fromMap(payload);
    await SettingsApi.clinicSettingsUpdate(f);
  }

  Future<void> createClinicDemo() async {
    await SettingsApi.createClinicDemo();
  }

  Future<Map<String, dynamic>> teamSettings() async {
    final res = await SettingsApi.teamSettings();
    return (res.data ?? const {}) as Map<String, dynamic>;
  }

  // -------- FIXED SIGNATURE (named params) --------
  Future<void> teamSettingsUpdate({
    Map<String, dynamic>? data,
    FormData? form,
  }) async {
    final f = form ?? FormData.fromMap(data ?? const {});
    await SettingsApi.teamSettingsUpdate(f);
  }

  Future<void> handleAutoRenewal(bool active) async {
    await SettingsApi.handleAutoRenewal(active);
  }

  Future<void> requestBackup() async {
    await SettingsApi.requestBackup();
  }

  Future<void> downloadBackup() async {
    await SettingsApi.downloadBackup();
  }
}
