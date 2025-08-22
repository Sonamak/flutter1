import 'dart:async';
import 'package:sonamak_flutter/core/realtime/realtime_adapter.dart';

/// Singleton wrapper to decouple the app from a specific adapter implementation.
class Realtime {
  Realtime._();
  static final Realtime I = Realtime._();

  RealtimeAdapter? _adapter;

  bool get isReady => _adapter != null;
  String? get socketId => _adapter?.socketId;

  Future<void> init(RealtimeAdapter adapter, {
    required String appKey,
    required String host,
    int wsPort = 6001,
    bool tls = false,
    String cluster = 'eu',
    Map<String, String>? headers,
    String? authEndpoint,
  }) async {
    _adapter = adapter;
    await _adapter!.connect(
      appKey: appKey,
      host: host,
      wsPort: wsPort,
      tls: tls,
      cluster: cluster,
      headers: headers,
      authEndpoint: authEndpoint,
    );
  }

  Future<void> subscribe(String channel) async {
    final a = _adapter;
    if (a == null) throw StateError('Realtime not initialized');
    await a.subscribe(channel);
  }

  Object on(String channel, String event, EventHandler handler) {
    final a = _adapter;
    if (a == null) throw StateError('Realtime not initialized');
    return a.bind(channel, event, handler);
  }

  void off(Object token) {
    _adapter?.unbind(token);
  }

  Future<void> unsubscribe(String channel) async {
    final a = _adapter;
    if (a == null) return;
    await a.unsubscribe(channel);
  }

  Future<void> dispose() async {
    final a = _adapter;
    _adapter = null;
    await a?.disconnect();
  }
}
