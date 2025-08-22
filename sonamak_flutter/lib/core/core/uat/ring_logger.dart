library ring_logger;

/// RingLogger — in‑memory, bounded log buffer suitable for UAT feedback attachments.
class RingLogger {
  RingLogger._(this.capacity);
  static final RingLogger I = RingLogger._(500);

  final int capacity;
  final List<String> _buf = <String>[];

  void add(String line) {
    _buf.add(_stamp(line));
    if (_buf.length > capacity) {
      _buf.removeAt(0);
    }
  }

  void clear() => _buf.clear();

  List<String> lines({int max = 200}) {
    if (_buf.length <= max) return List<String>.from(_buf);
    return _buf.sublist(_buf.length - max);
  }

  String dump({int max = 200}) => lines(max: max).join('\n');

  String _stamp(String line) {
    final ts = DateTime.now().toIso8601String();
    return '[$ts] $line';
  }
}
