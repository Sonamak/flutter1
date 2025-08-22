import 'dart:convert';
import 'dart:io';

class SecureStorage {
  static final Map<String, String> _mem = <String, String>{};
  static bool _loaded = false;
  static late final File _file;

  static Directory _configDir() {
    final env = Platform.environment;
    if (Platform.isWindows) {
      final appData = env['APPDATA'] ?? env['USERPROFILE'] ?? Directory.current.path;
      return Directory('${appData}\\Sonamak');
    } else if (Platform.isMacOS) {
      final home = env['HOME'] ?? Directory.current.path;
      return Directory('$home/Library/Application Support/Sonamak');
    } else if (Platform.isLinux) {
      final home = env['HOME'] ?? Directory.current.path;
      return Directory('$home/.config/sonamak');
    } else {
      return Directory('${Directory.current.path}/.sonamak');
    }
  }

  static Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final dir = _configDir();
    if (!await dir.exists()) await dir.create(recursive: true);
    _file = File('${dir.path}${Platform.pathSeparator}secure_store.json');
    if (await _file.exists()) {
      try {
        final text = await _file.readAsString();
        final decoded = jsonDecode(text);
        if (decoded is Map) {
          decoded.forEach((k, v) {
            if (k is String && v is String) _mem[k] = v;
          });
        }
      } catch (_) {
        _mem.clear();
      }
    }
    _loaded = true;
  }

  static Future<void> _flush() async {
    try {
      final tmp = File('${_file.path}.tmp');
      await tmp.writeAsString(jsonEncode(_mem), flush: true);
      if (await _file.exists()) await _file.delete();
      await tmp.rename(_file.path);
    } catch (_) {}
  }

  static Future<void> write(String key, String value) async {
    await _ensureLoaded();
    _mem[key] = value;
    await _flush();
  }

  static Future<String?> read(String key) async {
    await _ensureLoaded();
    return _mem[key];
  }

  static Future<void> delete(String key) async {
    await _ensureLoaded();
    _mem.remove(key);
    await _flush();
  }
}
