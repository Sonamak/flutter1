import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/data/services/api_config.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class ServerConfig {
  static const _kSub = 'tenant_subdomain';
  static const _kBase = 'tenant_base_url';
  static const _kOrigin = 'tenant_origin';

  static String? _subdomain;
  static String? _baseUrlOverride;
  static String? _originOverride;

  static String? get subdomain => _subdomain;
  static String get baseUrl => _baseUrlOverride ?? ApiConfig.baseUrl;
  static String get origin {
    if (_originOverride != null && _originOverride!.isNotEmpty) return _originOverride!;
    final base = baseUrl;
    final idx = base.indexOf('/api');
    return idx > 0 ? base.substring(0, idx) : base;
  }

  static Future<void> load() async {
    _subdomain = await SecureStorage.read(_kSub);
    _baseUrlOverride = await SecureStorage.read(_kBase);
    _originOverride = await SecureStorage.read(_kOrigin);
    HttpClient.rebase(baseUrl);
  }

  static Future<void> applyFromInput(String raw) async {
    final v = raw.trim();
    if (v.isEmpty) return;
    if (v.contains('://')) {
      await setBaseUrl(v);
    } else {
      await setSubdomain(v);
    }
  }

  static Future<void> setSubdomain(String sub) async {
    _subdomain = sub.trim();
    if (_subdomain == null || _subdomain!.isEmpty) return;
    final origin = 'https://${_subdomain!}.sonamak.net';
    final base = '$origin/api';
    _originOverride = origin;
    _baseUrlOverride = base;
    await SecureStorage.write(_kSub, _subdomain!);
    await SecureStorage.write(_kBase, base);
    await SecureStorage.write(_kOrigin, origin);
    HttpClient.rebase(base);
  }

  static Future<void> setBaseUrl(String url) async {
    var v = url.trim();
    if (!v.endsWith('/api')) v = v.endsWith('/') ? '${v}api' : '$v/api';
    final idx = v.indexOf('/api');
    final origin = idx > 0 ? v.substring(0, idx) : v;
    _subdomain = null;
    _originOverride = origin;
    _baseUrlOverride = v;
    await SecureStorage.delete(_kSub);
    await SecureStorage.write(_kBase, _baseUrlOverride!);
    await SecureStorage.write(_kOrigin, _originOverride!);
    HttpClient.rebase(_baseUrlOverride!);
  }
}
