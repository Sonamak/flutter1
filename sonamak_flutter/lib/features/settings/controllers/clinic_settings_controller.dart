import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/features/settings/data/settings_repository.dart';

class ClinicSettingsController extends ChangeNotifier {
  final SettingsRepository _repo = SettingsRepository();

  Map<String, dynamic> clinic = const {};
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    clinic = await _repo.clinicSettings();
    loading = false;
    notifyListeners();
  }

  /// Save clinic settings using **named** parameters (no positionals).
  Future<void> save({
    List<Map<String, dynamic>>? smsGroups,
    List<Map<String, dynamic>>? workingHours,
    Map<String, dynamic>? data,
    FormData? form,
  }) async {
    await _repo.clinicSettingsUpdate(
      smsGroups: smsGroups,
      workingHours: workingHours,
      data: data,
      form: form,
    );
    await load();
  }

  Future<void> createDemo() async {
    await _repo.createClinicDemo(); // no args expected
    await load();
  }
}
