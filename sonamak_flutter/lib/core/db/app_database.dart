import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'dart:io';
import 'package:path/path.dart' as p;

/// Minimal cross-platform SQLite database wrapper (Windows + mobile) with Outbox.
class AppDatabase {
  static AppDatabase? _instance;
  static AppDatabase get I => _instance ??= AppDatabase._();

  AppDatabase._();

  late final sqlite.Database _db;

  Future<void> open() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'sonamak.db'));
    _db = sqlite.sqlite3.open(file.path);
    _migrate();
  }

  void _migrate() {
    _db.execute('CREATE TABLE IF NOT EXISTS kv (k TEXT PRIMARY KEY, v TEXT NOT NULL)');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS outbox(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tenant TEXT NOT NULL DEFAULT '',
        endpoint TEXT NOT NULL,
        method TEXT NOT NULL,
        body_json TEXT NOT NULL,
        deps_json TEXT NOT NULL,
        attempts INTEGER NOT NULL DEFAULT 0,
        last_error TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    // Try to add tenant column in case of an older schema (ignore failures)
    try { _db.execute('ALTER TABLE outbox ADD COLUMN tenant TEXT NOT NULL DEFAULT ""'); } catch (_) {}
  }

  /// Simple KV helpers
  Future<void> put(String key, String value) async {
    final stmt = _db.prepare('INSERT OR REPLACE INTO kv(k,v) VALUES(?,?)');
    stmt.execute([key, value]);
    stmt.dispose();
  }

  String? get(String key) {
    final rs = _db.select('SELECT v FROM kv WHERE k=? LIMIT 1', [key]);
    return rs.isNotEmpty ? rs.first['v'] as String : null;
  }

  /// Outbox API expected by OutboxService
  int enqueue({required String tenant, required String endpoint, required String method, required String bodyJson, required String depsJson}) {
    final stmt = _db.prepare('INSERT INTO outbox(tenant,endpoint,method,body_json,deps_json) VALUES(?,?,?,?,?)');
    stmt.execute([tenant, endpoint, method, bodyJson, depsJson]);
    stmt.dispose();
    final rowId = _db.select('SELECT last_insert_rowid() AS id').first['id'] as int;
    return rowId;
  }

  List<Map<String, Object?>> nextOutboxBatch([int limit = 20]) {
    final rs = _db.select('SELECT * FROM outbox ORDER BY created_at ASC LIMIT ?', [limit]);
    return rs.map((r) => r).toList(growable: false);
  }

  void outboxMarkSuccess(int id) {
    _db.execute('DELETE FROM outbox WHERE id=?', [id]);
  }

  void outboxMarkFailure(int id, Object error) {
    _db.execute('UPDATE outbox SET attempts=attempts+1, last_error=? WHERE id=?', [error.toString(), id]);
  }
}
