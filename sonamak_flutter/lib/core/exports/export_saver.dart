import 'dart:io';
import 'dart:typed_data';

import 'package:sonamak_flutter/core/desktop/paths_windows.dart';
import 'package:sonamak_flutter/core/desktop/open_in_default.dart';
import 'package:sonamak_flutter/core/exports/filename_sanitizer.dart';

class ExportResult {
  final String path;
  final bool opened;
  const ExportResult(this.path, this.opened);
}

class ExportSaver {
  /// Save [bytes] under default exports directory, return the path.
  /// If [openAfterSave] is true, will attempt to open with OS default app.
  static Future<ExportResult> saveBytes({
    required Uint8List bytes,
    required String suggestedName,
    bool openAfterSave = false,
    String subfolder = '',
  }) async {
    final name = sanitizeFileName(suggestedName);
    final dir = _ensureDir(subfolder);
    final file = File(_join(dir.path, name));
    await file.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    var opened = false;
    if (openAfterSave) {
      opened = await OpenInDefault.open(file.path);
    }
    return ExportResult(file.path, opened);
  }

  static Directory _ensureDir(String subfolder) {
    Directory base;
    if (Platform.isWindows) {
      base = WindowsPaths.defaultExportsDir();
    } else {
      base = Directory('${Directory.current.path}/Exports');
    }
    if (!base.existsSync()) base.createSync(recursive: true);
    if (subfolder.isNotEmpty) {
      final d = Directory(_join(base.path, subfolder));
      if (!d.existsSync()) d.createSync(recursive: true);
      return d;
    }
    return base;
  }

  static String _join(String a, String b) {
    final sep = Platform.pathSeparator;
    if (a.endsWith(sep)) return a + b;
    return '$a$sep$b';
  }
}
