import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

enum LabSection { analysis, scanCenter, dentistry }

class LabApi {
  static Future<Response<dynamic>> getAllInitial({int page = 1, int perPage = 25}) {
    return HttpClient.I.post<dynamic>('/laboratory/all-data', data: {'page': page, 'per_page': perPage});
  }

  static Future<Response<dynamic>> getLabs({
    required LabSection section,
    String? q,
    String? from,
    String? to,
    int? branchId,
    int page = 1,
    int perPage = 25,
  }) {
    String path;
    switch (section) {
      case LabSection.dentistry:
        path = '/laboratory/dentist-laboratory';
        break;
      case LabSection.scanCenter:
        path = '/laboratory/scan-center';
        break;
      case LabSection.analysis:
        path = '/laboratory/all-data';
        break;
    }
    final data = <String, dynamic>{'page': page, 'per_page': perPage};
    if (q != null && q.isNotEmpty) data['q'] = q;
    if (from != null && from.isNotEmpty) data['from'] = from;
    if (to != null && to.isNotEmpty) data['to'] = to;
    if (branchId != null) data['branch_id'] = branchId;
    return HttpClient.I.post<dynamic>(path, data: data);
  }

  static Future<Response<Map<String, dynamic>>> savePaidUp(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/laboratory/save-paid-up', data: data);
  }

  static Future<Response<Map<String, dynamic>>> laboratoryPayOff(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/laboratory/pay-off', data: data);
  }

  static Future<Response<Map<String, dynamic>>> laboratoryActivation(Map<String, dynamic> data) {
    return HttpClient.I.post<Map<String, dynamic>>('/laboratory/activation', data: data);
  }

  static Future<Response<dynamic>> laboratoryExcelDownload({required LabSection section}) {
    final path = (section == LabSection.dentistry)
        ? '/laboratory/excel-dentist-laboratory'
        : '/laboratory/excel-download';
    return HttpClient.I.get<dynamic>(path);
  }
}