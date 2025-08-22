
import 'dart:async';

/// Simple debouncer to throttle rapid calls into one after [delay].
class Debouncer {
  Debouncer(this.delay);
  final Duration delay;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
