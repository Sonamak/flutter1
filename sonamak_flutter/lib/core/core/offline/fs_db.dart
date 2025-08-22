import 'dart:convert';
import 'dart:io';

/// A lightweight JSON-file backed store per collection.
/// Avoids external deps and works on Windows + mobile.
class FsDb {
  final Directory root;

  FsDb(this.root);

  static Future<FsDb> open({String? overridePath}) async {
    final String basePath = overridePath ?? _defaultRoot();
    final dir = Directory(basePath);
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    return FsDb(dir);
  }

  static String _defaultRoot() {
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'] ?? Directory.systemTemp.path;
      return '$appData/Sonamak';
    }
    // Mobile and others: use temp as fallback; real app can pass a persistent path.
    return '${Directory.systemTemp.path}/sonamak';
  }

  File _fileFor(String collection) => File('${root.path}/$collection.json');

  Future<void> _ensure(String collection) async {
    final f = _fileFor(collection);
    if (!(await f.exists())) {
      await f.writeAsString(jsonEncode([]));
    }
  }

  Future<List<Map<String, dynamic>>> loadAll(String collection) async {
    await _ensure(collection);
    final raw = await _fileFor(collection).readAsString();
    final data = jsonDecode(raw);
    if (data is List) {
      return data.whereType<Map>().map((e) => e.map((k, v) => MapEntry(k.toString(), v))).toList();
    }
    return const [];
  }

  Future<void> saveAll(String collection, List<Map<String, dynamic>> rows) async {
    await _ensure(collection);
    final f = _fileFor(collection);
    await f.writeAsString(jsonEncode(rows));
  }

  Future<void> upsert(String collection, Map<String, dynamic> row, {String idKey = 'id'}) async {
    final rows = await loadAll(collection);
    final id = row[idKey];
    int index = rows.indexWhere((e) => e[idKey] == id);
    if (index >= 0) {
      rows[index] = row;
    } else {
      rows.add(row);
    }
    await saveAll(collection, rows);
  }

  Future<void> remove(String collection, dynamic id, {String idKey = 'id'}) async {
    final rows = await loadAll(collection);
    rows.removeWhere((e) => e[idKey] == id);
    await saveAll(collection, rows);
  }
}
