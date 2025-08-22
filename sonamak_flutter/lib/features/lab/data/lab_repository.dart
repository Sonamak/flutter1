import 'package:sonamak_flutter/features/lab/data/lab_api.dart';
import 'package:sonamak_flutter/features/lab/data/lab_models.dart';

class LabRepository {
  Future<List<LabOrderLite>> initial({int page = 1, int perPage = 25}) async {
    final res = await LabApi.getAllInitial(page: page, perPage: perPage);
    final data = res.data;
    List<dynamic> list;
    if (data is Map && data['payload'] is Map && data['payload']['data'] is List) {
      list = (data['payload']['data'] as List);
    } else if (data is Map && data['data'] is List) {
      list = (data['data'] as List);
    } else if (data is List) {
      list = data;
    } else {
      list = const [];
    }
    return list.whereType<Map<String, dynamic>>().map((e) => LabOrderLite.fromJson(e)).toList(growable: false);
  }

  Future<List<LabOrderLite>> fetch({
    LabSection section = LabSection.analysis,
    String? q,
    String? from,
    String? to,
    int? branchId,
    int page = 1,
    int perPage = 25,
  }) async {
    final res = await LabApi.getLabs(
      section: section,
      q: q,
      from: from,
      to: to,
      branchId: branchId,
      page: page,
      perPage: perPage,
    );
    final data = res.data;
    List<dynamic> list;
    if (data is Map && data['payload'] is Map && data['payload']['data'] is List) {
      list = (data['payload']['data'] as List);
    } else if (data is Map && data['data'] is List) {
      list = (data['data'] as List);
    } else if (data is List) {
      list = data;
    } else {
      list = const [];
    }
    return list.whereType<Map<String, dynamic>>().map((e) => LabOrderLite.fromJson(e)).toList(growable: false);
  }

  Future<void> savePaidUp({required int id, required num amount}) async {
    await LabApi.savePaidUp({'id': id, 'amount': amount});
  }

  Future<void> payOff({required int id}) async {
    await LabApi.laboratoryPayOff({'id': id});
  }

  Future<void> activate({required int id, required bool active}) async {
    await LabApi.laboratoryActivation({'id': id, 'active': active ? 1 : 0});
  }

  Future<void> exportExcel({LabSection section = LabSection.analysis}) async {
    await LabApi.laboratoryExcelDownload(section: section);
  }
}