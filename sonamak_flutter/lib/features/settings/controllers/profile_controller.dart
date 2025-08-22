import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/features/settings/data/settings_repository.dart';

class ProfileController extends ChangeNotifier {
  final SettingsRepository _repo = SettingsRepository();

  Map<String, dynamic> profile = const {};
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    profile = await _repo.profileInformation();
    loading = false;
    notifyListeners();
  }

  /// Save profile using **named** parameters (no positionals).
  Future<void> save({
    Map<String, dynamic>? data,
    dynamic images,
    FormData? form,
  }) async {
    await _repo.profileSettingsUpdate(
      data: data,
      images: images,
      form: form,
    );
    await load();
  }
}
