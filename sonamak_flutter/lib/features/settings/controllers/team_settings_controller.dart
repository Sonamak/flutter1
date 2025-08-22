import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/features/settings/data/settings_repository.dart';

class TeamSettingsController extends ChangeNotifier {
  final SettingsRepository _repo = SettingsRepository();

  Map<String, dynamic> team = const {};
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    team = await _repo.teamSettings();
    loading = false;
    notifyListeners();
  }

  /// Save team settings using **named** parameters (no positionals).
  Future<void> save({
    Map<String, dynamic>? data,
    FormData? form,
  }) async {
    await _repo.teamSettingsUpdate(
      data: data,
      form: form,
    );
    await load();
  }

  Future<void> handleAutoRenewal(bool active) async {
    await _repo.handleAutoRenewal(active);
    await load();
  }

  Future<void> requestBackup() => _repo.requestBackup();
  Future<void> downloadBackup() => _repo.downloadBackup();
}
