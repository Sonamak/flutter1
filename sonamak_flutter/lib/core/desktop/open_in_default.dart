import 'dart:io';

/// Open a file with the OS default handler (works on Windows desktop; no-op on other platforms).
class OpenInDefault {
  /// Returns true if a launch attempt was made.
  static Future<bool> open(String filePath) async {
    try {
      if (Platform.isWindows) {
        // Use CMD 'start' with quoted empty title argument to handle spaces
        await Process.start('cmd', ['/c', 'start', '', filePath], runInShell: true);
        return true;
      }
    } catch (_) {}
    return false;
  }
}
