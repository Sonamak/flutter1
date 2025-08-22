import 'dart:async';
import 'dart:convert';

import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/app/env/env_config.dart';

/// FeatureFlags — runtime feature flag store (opt-in by module).
/// - Persisted in SecureStorage under 'feature_flags'
/// - Seeds from defaults below; master bypass via EnvConfig.enableFeatureFlags
class FeatureFlags {
  FeatureFlags._();
  static final FeatureFlags I = FeatureFlags._();

  static const _storageKey = 'feature_flags';
  final Map<String, bool> _flags = <String, bool>{};
  final StreamController<Map<String, bool>> _changes = StreamController.broadcast();

  Stream<Map<String, bool>> get changes => _changes.stream;

  /// Default flags (conservative: OFF unless explicitly enabled)
  static const Map<String, bool> _defaults = {
    'feature.calendar': false,
    'feature.patients': false,
    'feature.finance': false,
    'feature.store': false,
    'feature.insurance': false,
    'feature.lab': false,
    'feature.dashboard': false,
    'feature.settings': false,
    'feature.tumors': false,
    'feature.tumorsAdv': false,
    'feature.realtime': false,
    'feature.exports': true,   // safe to keep ON if Phase-9 is integrated
    'feature.offline': false,
    'feature.developerMenu': false,
  };

  Future<void> load() async {
    _flags
      ..clear()
      ..addAll(_defaults);
    final text = await SecureStorage.read(_storageKey);
    if (text != null && text.trim().isNotEmpty) {
      try {
        final m = jsonDecode(text);
        if (m is Map) {
          m.forEach((k, v) {
            if (v is bool) _flags[k.toString()] = v;
          });
        }
      } catch (_) {}
    }
    _changes.add(Map<String, bool>.from(_flags));
  }

  Future<void> set(String key, bool enabled) async {
    _flags[key] = enabled;
    await SecureStorage.write(_storageKey, jsonEncode(_flags));
    _changes.add(Map<String, bool>.from(_flags));
  }

  /// If EnvConfig.enableFeatureFlags == false (master bypass), features read as enabled.
  bool isEnabled(String key) {
    if (!EnvConfig.enableFeatureFlags) return true;
    return _flags[key] ?? false;
  }

  Map<String, bool> snapshot() => Map<String, bool>.from(_flags);
}
