import 'dart:convert';

import 'package:sonamak_flutter/core/db/app_database.dart';

/// Simple Outbox service over [AppDatabase].
class OutboxService {
  OutboxService(this._db);
  final AppDatabase _db;

  /// Enqueue a request into the local outbox.
  Future<int> enqueue({
    required String tenant,
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    List<Map<String, dynamic>> deps = const [],
  }) async {
    final id = _db.enqueue(
      tenant: tenant,
      endpoint: endpoint,
      method: method.toUpperCase(),
      bodyJson: jsonEncode(body ?? const <String, dynamic>{}),
      depsJson: jsonEncode(deps),
    );
    return id;
  }

  /// Read next batch (FIFO). [limit] is positional `int` as required by AppDatabase.
  Future<List<Map<String, dynamic>>> nextBatch([int limit = 20]) async {
    final rows = _db.nextOutboxBatch(limit);
    return rows
        .map((r) => {
              'id': r['id'] as int,
              'tenant': (r['tenant'] ?? '').toString(),
              'endpoint': (r['endpoint'] ?? '').toString(),
              'method': (r['method'] ?? '').toString(),
              'body': jsonDecode((r['body_json'] ?? '{}').toString()) as Map<String, dynamic>,
              'deps': jsonDecode((r['deps_json'] ?? '[]').toString()) as List<dynamic>,
              'attempts': (r['attempts'] ?? 0) as int,
              'last_error': (r['last_error'] ?? '').toString(),
            })
        .toList(growable: false);
  }

  Future<void> markSuccess(int id) async => _db.outboxMarkSuccess(id);

  Future<void> markFailure(int id, Object error) async => _db.outboxMarkFailure(id, error);
}
