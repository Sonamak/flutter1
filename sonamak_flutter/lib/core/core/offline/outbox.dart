import 'package:dio/dio.dart';

import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/offline/fs_db.dart';

class OutboxEntry {
  final int id;
  final String endpoint;
  final String method;
  final Map<String, dynamic> body;
  final Map<String, dynamic> deps;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;

  OutboxEntry({
    required this.id,
    required this.endpoint,
    required this.method,
    required this.body,
    this.deps = const {},
    required this.createdAt,
    this.attempts = 0,
    this.lastError,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'endpoint': endpoint,
    'method': method,
    'body': body,
    'deps': deps,
    'created_at': createdAt.toIso8601String(),
    'attempts': attempts,
    'last_error': lastError,
  };

  static OutboxEntry fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return OutboxEntry(
      id: toInt(json['id']),
      endpoint: (json['endpoint'] ?? '').toString(),
      method: (json['method'] ?? 'POST').toString().toUpperCase(),
      body: (json['body'] as Map?)?.cast<String, dynamic>() ?? const {},
      deps: (json['deps'] as Map?)?.cast<String, dynamic>() ?? const {},
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      attempts: toInt(json['attempts'] ?? 0),
      lastError: json['last_error']?.toString(),
    );
  }
}

class Outbox {
  static const collection = 'outbox';
  final FsDb _db;
  Outbox(this._db);

  Future<List<OutboxEntry>> list() async {
    final rows = await _db.loadAll(collection);
    return rows.map(OutboxEntry.fromJson).toList();
  }

  Future<void> enqueue({
    required String endpoint,
    required String method,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> deps = const {},
  }) async {
    final rows = await _db.loadAll(collection);
    final nextId = (rows.map((e) => (e['id'] as int?) ?? 0).fold<int>(0, (p, c) => c > p ? c : p)) + 1;
    final entry = OutboxEntry(
      id: nextId,
      endpoint: endpoint,
      method: method.toUpperCase(),
      body: body,
      deps: deps,
      createdAt: DateTime.now(),
    );
    rows.add(entry.toJson());
    await _db.saveAll(collection, rows);
  }

  Future<void> remove(int id) async {
    final rows = await _db.loadAll(collection);
    rows.removeWhere((e) => e['id'] == id);
    await _db.saveAll(collection, rows);
  }

  /// Replay all entries in FIFO order. Caller should handle connectivity gating.
  Future<void> processAll() async {
    final dio = HttpClient.I;
    final rows = await _db.loadAll(collection);
    final entries = rows.map(OutboxEntry.fromJson).toList()..sort((a,b)=>a.id.compareTo(b.id));
    for (final e in entries) {
      try {
        await dio.request(
          e.endpoint,
          data: e.body,
          options: Options(method: e.method),
        );
        // If server returns new IDs, the caller (domain repository) should handle ID remapping;
        // Here we simply drop the entry on success.
        await remove(e.id);
      } catch (err) {
        // Update attempts / last_error
        final rows2 = await _db.loadAll(collection);
        for (final r in rows2) {
          if (r['id'] == e.id) {
            r['attempts'] = (r['attempts'] ?? 0) + 1;
            r['last_error'] = err.toString();
            break;
          }
        }
        await _db.saveAll(collection, rows2);
      }
    }
  }
}
