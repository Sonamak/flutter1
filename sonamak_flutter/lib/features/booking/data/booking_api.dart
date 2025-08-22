import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class BookingApi {
  static Future<Response<List<dynamic>>> fetchDoctorsRaw({
    dynamic dateNow, // String or DateTime
    int? branchId,
    int? clinicId,
    int? specialityId,
    int? doctorId,
  }) {
    String? date;
    if (dateNow != null) {
      if (dateNow is DateTime) {
        date = dateNow.toIso8601String();
      } else {
        date = dateNow.toString();
      }
    }
    final q = <String, dynamic>{
      if (branchId != null) 'branch': branchId,
      if (clinicId != null) 'clinic': clinicId,
      if (specialityId != null) 'speciality': specialityId,
      if (doctorId != null) 'doctor': doctorId,
      if (date != null) 'date': date,
    };
    return HttpClient.I.get<List<dynamic>>('/users/work-branch', queryParameters: q.isEmpty ? null : q);
  }

  static Future<Response<List<dynamic>>> fetchSpecialities([dynamic _]) =>
      HttpClient.I.get<List<dynamic>>('/booking/speciality');

  static Future<Response<Map<String, dynamic>>> createBooking(Map<String, dynamic> data) =>
      HttpClient.I.post<Map<String, dynamic>>('/booking/create', data: data);

  static Future<Response<Map<String, dynamic>>> findPatientByPhone(String phone) =>
      HttpClient.I.get<Map<String, dynamic>>('/calendar/get-patient', queryParameters: {'phone': phone});
}
