import 'dart:io';

import 'package:sonamak_flutter/core/offline/outbox_item.dart';

class OutboxPersistence {
  static File? _file;

  static Future<File> _ensureFile() async {
    if (_file != null) return _file!;
    final base = await _appDataDir();
    if (!await base.exists()) await base.create(recursive: true);
    final f = File('${base.path}${Platform.pathSeparator}offline_outbox.json');
    if (!await f.exists()) {
      await f.writeAsString('[]', flush: true);
    }
    _file = f;
    return f;
  }

  static Future<Directory> _appDataDir() async {
    final env = Platform.environment;
    if (Platform.isWindows) {
      final appData = env['APPDATA'] ?? env['USERPROFILE'] ?? Directory.current.path;
      return Directory('$appData\\Sonamak');
    } else if (Platform.isMacOS) {
      final home = env['HOME'] ?? Directory.current.path;
      return Directory('$home/Library/Application Support/Sonamak');
    } else {
      final home = env['HOME'] ?? Directory.current.path;
      return Directory('$home/.sonamak');
    }
  }

  static Future<List<OutboxItem>> readAll() async {
    final f = await _ensureFile();
    try {
      final text = await f.readAsString();
      return OutboxStore.parse(text).items;
    } catch (_) {
      return const [];
    }
  }

  static Future<void> writeAll(List<OutboxItem> items) async {
    final f = await _ensureFile();
    await f.writeAsString(OutboxStore.serialize(items), flush: true);
  }
}
