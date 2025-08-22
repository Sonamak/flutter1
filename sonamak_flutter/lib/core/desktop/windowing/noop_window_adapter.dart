import 'window_adapter.dart';

/// Default NO-OP adapter that compiles on all targets (Windows, mobile).
class NoopWindowAdapter extends WindowAdapter {
  @override
  Future<void> init() async {}
  @override
  Future<void> setMinimumSize(double width, double height) async {}
  @override
  Future<void> setSize(double width, double height) async {}
  @override
  Future<void> center() async {}
  @override
  Future<void> setAlwaysOnTop(bool value) async {}
  @override
  Future<void> setTitle(String title) async {}
  @override
  Future<void> maximize() async {}
  @override
  Future<void> restore() async {}
}
