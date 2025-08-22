library realtime;

typedef EventHandler = void Function(String event, dynamic data);

/// Abstract adapter so we can plug different realtime backends (Pusher, Ably, etc.).
abstract class RealtimeAdapter {
  /// Initialize a connection. Returns when connected or throws on fatal error.
  Future<void> connect({
    required String appKey,
    required String host,
    required int wsPort,
    bool tls = false,
    String cluster = 'eu',
    Map<String, String>? headers,
    String? authEndpoint,
  });

  /// Subscribe to a channel (e.g., 'private-calendar', 'presence-requests').
  Future<void> subscribe(String channel);

  /// Bind to an event name within the current channel; return a token to unbind.
  Object bind(String channel, String event, EventHandler handler);

  /// Unbind a specific handler registration.
  void unbind(Object token);

  /// Unsubscribe channel completely.
  Future<void> unsubscribe(String channel);

  /// Current socket id if available (used for X-Socket-Id header).
  String? get socketId;

  /// Disconnect gracefully.
  Future<void> disconnect();
}
