import 'package:sonamak_flutter/core/realtime/realtime_adapter.dart';

/// Stub adapter — compiles without the pusher_channels_flutter plugin.
/// Replace this file with a real adapter when you add the plugin.
class PusherChannelsAdapter implements RealtimeAdapter {
  String? _socketId;
  @override
  String? get socketId => _socketId;

  @override
  Future<void> connect({required String appKey, required String host, required int wsPort, bool tls = false, String cluster = 'eu', Map<String, String>? headers, String? authEndpoint,}) async {
    // No-op: provide a fake socket id to enable X-Socket-Id header behavior if needed
    _socketId = null;
  }

  @override
  Object bind(String channel, String event, EventHandler handler) {
    // Return a token; no binding occurs in stub
    return Object();
  }

  @override
  Future<void> subscribe(String channel) async {}

  @override
  void unbind(Object token) {}

  @override
  Future<void> unsubscribe(String channel) async {}

  @override
  Future<void> disconnect() async {}
}
