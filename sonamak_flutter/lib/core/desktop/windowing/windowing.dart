import 'dart:io' show Platform;
import 'window_adapter.dart';
import 'noop_window_adapter.dart';

/// App-facing facade. By default uses a NO-OP adapter.
/// If you add a real adapter (e.g., `window_manager` plugin), replace [adapter] initialization.
class Windowing {
  Windowing._();
  static final Windowing I = Windowing._();

  WindowAdapter adapter = NoopWindowAdapter();

  bool get isWindows => Platform.isWindows;

  Future<void> bootstrap({
    double? minWidth,
    double? minHeight,
    double? initialWidth,
    double? initialHeight,
    bool alwaysOnTop = false,
    String? title,
  }) async {
    await adapter.init();
    if (minWidth != null && minHeight != null) {
      await adapter.setMinimumSize(minWidth, minHeight);
    }
    if (initialWidth != null && initialHeight != null) {
      await adapter.setSize(initialWidth, initialHeight);
      await adapter.center();
    }
    if (title != null) {
      await adapter.setTitle(title);
    }
    if (alwaysOnTop) {
      await adapter.setAlwaysOnTop(true);
    }
  }
}
