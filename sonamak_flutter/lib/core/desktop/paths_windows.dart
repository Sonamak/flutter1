import 'dart:io';

/// Compute a safe default path for Exports on Windows:
/// %USERPROFILE%\Documents\Sonamak\Exports
class WindowsPaths {
  static Directory defaultExportsDir() {
    final env = Platform.environment;
    final home = env['USERPROFILE'] ?? Directory.current.path;
    final docs = Directory('$home\\Documents');
    final dir = Directory('${docs.path}\\Sonamak\\Exports');
    return dir;
  }
}
