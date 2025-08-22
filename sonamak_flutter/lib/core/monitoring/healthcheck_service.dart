import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

enum HealthState { up, down, unknown }

class HealthSample {
  final HealthState state;
  final int latencyMs;
  final DateTime at;
  const HealthSample(this.state, this.latencyMs, this.at);
}

/// HealthcheckService — periodic ping to a configurable path; broadcasts samples.
class HealthcheckService {
  HealthcheckService({this.path = '/health', this.interval = const Duration(seconds: 30)});
  final String path;
  final Duration interval;

  final _controller = StreamController<HealthSample>.broadcast();
  Stream<HealthSample> get stream => _controller.stream;

  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _probe());
    _probe(); // initial
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _probe() async {
    final t0 = DateTime.now().millisecondsSinceEpoch;
    try {
      final res = await HttpClient.I.get(path, options: Options(responseType: ResponseType.json));
      final t1 = DateTime.now().millisecondsSinceEpoch;
      final ok = (res.statusCode ?? 0) >= 200 && (res.statusCode ?? 0) < 500;
      _controller.add(HealthSample(ok ? HealthState.up : HealthState.down, t1 - t0, DateTime.now()));
    } catch (_) {
      final t1 = DateTime.now().millisecondsSinceEpoch;
      _controller.add(HealthSample(HealthState.down, t1 - t0, DateTime.now()));
    }
  }
}
