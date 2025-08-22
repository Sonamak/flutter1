library windowing;

/// Abstract adapter for desktop window controls (min size, center, etc.).
/// This file defines the API; the default app uses a NO-OP adapter that compiles everywhere.
abstract class WindowAdapter {
  /// Initialize any window-specific state. Safe to call multiple times.
  Future<void> init() async {}

  /// Set minimum window size in pixels (logical). If unsupported, ignore.
  Future<void> setMinimumSize(double width, double height) async {}

  /// Attempt to set current window size. If unsupported, ignore.
  Future<void> setSize(double width, double height) async {}

  /// Center the window on the current display. If unsupported, ignore.
  Future<void> center() async {}

  /// Toggle always-on-top flag. If unsupported, ignore.
  Future<void> setAlwaysOnTop(bool value) async {}

  /// Set window title (fallback to app name if unsupported).
  Future<void> setTitle(String title) async {}

  /// Maximize/Restore if supported.
  Future<void> maximize() async {}
  Future<void> restore() async {}
}
