
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/features/patients/data/patient_api.dart';
import 'package:sonamak_flutter/features/patients/data/patient_models.dart';

class PatientRepository {
  dynamic _unwrap(dynamic v) {
    if (v == null) return null;
    dynamic x = v;
    if (x is String) { try { x = jsonDecode(x); } catch (_) {} }
    if (x is Map) {
      if (x.containsKey('payload')) return _unwrap(x['payload']);
      if (x.containsKey('data')) return _unwrap(x['data']);
      if (x.containsKey('rows')) return _unwrap(x['rows']);
      return x;
    }
    return x;
  }

  List<Map<String, dynamic>> _asMapList(dynamic v) {
    final u = _unwrap(v);
    if (u is List) {
      return u.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  Future<List<PatientLite>> _pageToLite({
    required int page,
    required int perPage,
    int? branchId,
    String? q,
  }) async {
    final Response<List<dynamic>> res = await PatientApi.listPage(branchId: branchId, q: q, page: page, perPage: perPage);
    final list = _asMapList(res.data);
    return list.map(PatientLite.fromJson).toList(growable: false);
  }

  /// Fetch **all** patients by paging until the server stops returning more.
  Future<List<PatientLite>> listAllAllPages({int? branchId, int perPage = 200, int maxPages = 100}) async {
    final all = <PatientLite>[];
    for (int page = 1; page <= maxPages; page++) {
      final chunk = await _pageToLite(page: page, perPage: perPage, branchId: branchId);
      all.addAll(chunk);
      if (chunk.length < perPage) break;
    }
    return all;
  }

  /// Search across all pages (q param), with branch filter if present.
  Future<List<PatientLite>> searchAllPages(String term, {int? branchId, int perPage = 200, int maxPages = 100}) async {
    final all = <PatientLite>[];
    for (int page = 1; page <= maxPages; page++) {
      final chunk = await _pageToLite(page: page, perPage: perPage, branchId: branchId, q: term);
      all.addAll(chunk);
      if (chunk.length < perPage) break;
    }
    return all;
  }

  // Back-compat single page (kept for controllers that still call these)
  Future<List<PatientLite>> listAll({int? branchId}) async {
    return _pageToLite(page: 1, perPage: 200, branchId: branchId);
  }

  Future<List<PatientLite>> searchBy(String term, {int? branchId}) async {
    return _pageToLite(page: 1, perPage: 200, branchId: branchId, q: term);
  }

  Future<PatientProfile> getProfile(int id) async {
    final Response<Map<String, dynamic>> res = await PatientApi.getProfile(id);
    final m = _unwrap(res.data) as Map? ?? <String, dynamic>{};
    return PatientProfile.fromJson(m.cast<String, dynamic>());
  }

  Future<PatientProfile?> getProfileByAnyId(dynamic id) async {
    final parsed = int.tryParse('$id');
    if (parsed != null) return getProfile(parsed);
    return null;
  }

  Future<PatientProfile> update(Map<String, dynamic> data) async {
    await PatientApi.update(data);
    final anyId = data['id'] ?? data['patient_id'] ?? data['patientId'];
    final parsed = int.tryParse('$anyId');
    if (parsed != null) {
      return getProfile(parsed);
    }
    final Response<Map<String, dynamic>> res = await PatientApi.getProfile(data['id'] ?? 0);
    final m = _unwrap(res.data) as Map? ?? <String, dynamic>{};
    return PatientProfile.fromJson(m.cast<String, dynamic>());
  }

  Future<void> create(Map<String, dynamic> data) async { await PatientApi.create(data); }
  Future<void> remove(int id) async { await PatientApi.remove(id); }

  Future<List<Map<String, dynamic>>> examinations(int patientId) async {
    final Response<List<dynamic>> res = await PatientApi.examinations(patientId);
    return _asMapList(res.data);
  }
}
