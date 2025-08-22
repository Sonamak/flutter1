import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/network/idempotency_key.dart';
import 'package:sonamak_flutter/core/offline/outbox_item.dart';
import 'package:sonamak_flutter/core/offline/outbox_persistence.dart';

class OutboxProcessor {
  OutboxProcessor._();
  static final OutboxProcessor I = OutboxProcessor._();

  Timer? _timer;
  bool _running = false;

  Future<void> enqueue({
    required String method,
    required String path,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final id = IdempotencyKey.generate(prefix: 'obx');
    final item = OutboxItem(
      id: id,
      method: method.toUpperCase(),
      url: path,
      headers: headers,
      body: body,
      createdAt: DateTime.now(),
      attempts: 0,
      maxAttempts: 5,
      idempotencyKey: id,
    );
    final list = await OutboxPersistence.readAll();
    list.add(item);
    await OutboxPersistence.writeAll(list);
    _schedule();
  }

  Future<void> flush() async {
    if (_running) return;
    _running = true;
    try {
      var items = await OutboxPersistence.readAll();
      final keep = <OutboxItem>[];
      for (final it in items) {
        final ok = await _trySend(it);
        if (!ok) {
          final next = it.copyWith(attempts: it.attempts + 1);
          if (next.attempts < next.maxAttempts) {
            keep.add(next);
          }
        }
      }
      await OutboxPersistence.writeAll(keep);
    } finally {
      _running = false;
    }
    final remaining = await OutboxPersistence.readAll();
    if (remaining.isNotEmpty) _schedule(backoffFor(remaining.first.attempts));
  }

  Duration backoffFor(int attempts) {
    final secs = pow(attempts + 1, 2).toInt().clamp(1, 300);
    return Duration(seconds: secs);
  }

  void _schedule([Duration? after]) {
    _timer?.cancel();
    _timer = Timer(after ?? const Duration(seconds: 2), flush);
  }

  Future<bool> _trySend(OutboxItem it) async {
    try {
      final res = await _request(it);
      final code = res.statusCode ?? 0;
      if (code >= 200 && code < 300) return true;
      if (code == 409) return true;
      if (code >= 500) return false;
      return true;
    } on DioException {
      return false;
    } catch (_) {
      return true;
    }
  }

  Future<Response> _request(OutboxItem it) {
    final dio = HttpClient.I;
    final opts = Options(
      method: it.method,
      headers: {
        if (it.headers != null) ...it.headers!,
        'X-Idempotency-Key': it.idempotencyKey,
      },
    );
    return dio.request(it.url, data: it.body, options: opts);
  }
}
