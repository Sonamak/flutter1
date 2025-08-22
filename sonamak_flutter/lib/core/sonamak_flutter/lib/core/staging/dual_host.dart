import 'package:sonamak_flutter/core/utils/server_config.dart';

/// DualHost — keep both production and staging targets and switch easily.
class DualHost {
  static String? _prod;
  static String? _staging;
  static String _current = 'prod';

  static String get current => _current;

  /// Save production host input (subdomain or full URL) and set current target to prod.
  static Future<void> setProduction(String subdomainOrUrl) async {
    _prod = subdomainOrUrl;
    _current = 'prod';
    await _apply(subdomainOrUrl);
  }

  /// Save staging host input (subdomain or full URL) and set current target to staging.
  static Future<void> setStaging(String subdomainOrUrl) async {
    _staging = subdomainOrUrl;
    _current = 'staging';
    await _apply(subdomainOrUrl);
  }

  /// Toggle to the other target if available.
  static Future<void> toggle() async {
    if (_current == 'prod' && _staging != null) {
      _current = 'staging';
      await _apply(_staging!);
    } else if (_current == 'staging' && _prod != null) {
      _current = 'prod';
      await _apply(_prod!);
    }
  }

  static Future<void> _apply(String v) => ServerConfig.applyFromInput(v);
}
