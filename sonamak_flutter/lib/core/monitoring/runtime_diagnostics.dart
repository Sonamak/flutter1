import 'dart:io';
import 'package:sonamak_flutter/core/utils/server_config.dart';
import 'package:sonamak_flutter/core/utils/locale_manager.dart';
import 'package:sonamak_flutter/app/env/env_config.dart';

class RuntimeDiagnostics {
  static Map<String, dynamic> snapshot() {
    return {
      'platform': {
        'os': Platform.operatingSystem,
        'version': Platform.operatingSystemVersion,
        'isWindows': Platform.isWindows,
        'dart': Platform.version,
      },
      'network': {
        'baseUrl': ServerConfig.baseUrl,
        'origin': ServerConfig.origin,
        'xLocalization': LocaleManager.headerValue(),
      },
      'env': {
        'apiBaseUrl': EnvConfig.apiBaseUrl,
        'pusherKey': (EnvConfig.pusherKey.isEmpty ? '(unset)' : '***'),
        'featureFlagsEnabled': EnvConfig.enableFeatureFlags,
        'defaultLocale': EnvConfig.defaultLocale.toLanguageTag(),
      },
      'time': DateTime.now().toIso8601String(),
    };
  }
}
