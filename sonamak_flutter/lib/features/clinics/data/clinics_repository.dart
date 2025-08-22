
import 'package:sonamak_flutter/features/clinics/data/clinics_api.dart';
import 'package:sonamak_flutter/features/clinics/data/clinics_models.dart';

class ClinicsRepository {
  Future<List<Clinic>> list() async {
    final res = await ClinicsApi.getAll();
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map((e) => Clinic.fromJson(e)).toList(growable: false);
    }

  Future<Clinic?> handle(Map<String, dynamic> payload) async {
    final res = await ClinicsApi.handle(payload);
    final d = res.data;
    if (d is Map<String, dynamic>) return Clinic.fromJson(d);
    return null;
  }

  Future<void> addExtras({required int clinicId, required List<Map<String, dynamic>> extras}) async {
    await ClinicsApi.addExtra({'id': clinicId, 'extras': extras});
  }

  Future<void> changeSuspend({required int clinicId, required bool active}) async {
    await ClinicsApi.changeSuspend({'id': clinicId, 'active': active});
  }

  Future<void> updateSubscription(Subscription s) async {
    await ClinicsApi.updateSubscription(s.toUpdatePayload());
  }

  Future<List<ExtraItem>> extrasByCountry(String country) async {
    final res = await ClinicsApi.getExtras(country);
    final data = res.data ?? const [];
    return data.whereType<Map<String, dynamic>>().map((e) => ExtraItem.fromJson(e)).toList(growable: false);
  }
}
