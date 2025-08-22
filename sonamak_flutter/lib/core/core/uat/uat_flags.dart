import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';

class UatFlags {
  static const _kEnabled = 'uat_enabled';
  static const _kSession = 'uat_session_id';

  static final ValueNotifier<bool> enabled = ValueNotifier(false);
  static final ValueNotifier<String?> sessionId = ValueNotifier(null);

  static Future<void> load() async {
    final e = await SecureStorage.read(_kEnabled);
    final s = await SecureStorage.read(_kSession);
    enabled.value = e == '1';
    sessionId.value = (s != null && s.isNotEmpty) ? s : null;
  }

  static Future<void> setEnabled(bool v) async {
    enabled.value = v;
    await SecureStorage.write(_kEnabled, v ? '1' : '0');
  }

  static Future<void> setSessionId(String? id) async {
    sessionId.value = (id != null && id.isNotEmpty) ? id : null;
    if (sessionId.value == null) {
      await SecureStorage.delete(_kSession);
    } else {
      await SecureStorage.write(_kSession, sessionId.value!);
    }
  }
}
