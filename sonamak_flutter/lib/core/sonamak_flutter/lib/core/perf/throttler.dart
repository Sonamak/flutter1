
/// Ensures actions are not executed more than once per [interval].
class Throttler {
  Throttler(this.interval);
  final Duration interval;
  DateTime? _last;

  bool tryRun(void Function() action) {
    final now = DateTime.now();
    if (_last == null || now.difference(_last!) >= interval) {
      _last = now;
      action();
      return true;
    }
    return false;
  }
}
