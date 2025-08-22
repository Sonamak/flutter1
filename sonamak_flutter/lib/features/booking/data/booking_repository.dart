export 'booking_models.dart';

import 'package:sonamak_flutter/features/booking/data/booking_api.dart';
import 'package:sonamak_flutter/features/booking/data/booking_models.dart';

class BookingRepository {
  Future<List<DoctorLite>> fetchDoctorsRaw({
    dynamic dateNow, // String or DateTime
    int? branchId,
    int? clinicId,
    int? specialityId,
    int? doctorId,
  }) async {
    final res = await BookingApi.fetchDoctorsRaw(
      dateNow: dateNow,
      branchId: branchId,
      clinicId: clinicId,
      specialityId: specialityId,
      doctorId: doctorId,
    );
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(DoctorLite.fromJson).toList(growable: false);
  }

  Future<List<Speciality>> fetchSpecialities([dynamic _]) async {
    final res = await BookingApi.fetchSpecialities(_);
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map(Speciality.fromJson).toList(growable: false);
  }

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> payload) async {
    final res = await BookingApi.createBooking(payload);
    return (res.data ?? const {});
  }

  Future<Map<String, dynamic>> findPatientByPhone(String phone) async {
    final res = await BookingApi.findPatientByPhone(phone);
    return (res.data ?? const {});
  }
}
