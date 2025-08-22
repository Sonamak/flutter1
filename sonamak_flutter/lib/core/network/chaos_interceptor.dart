import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

/// Dev-only interceptor that injects artificial latency and random failures.
class ChaosInterceptor extends Interceptor {
  ChaosInterceptor({this.minLatencyMs = 0, this.maxLatencyMs = 0, this.errorRate = 0.0});

  int minLatencyMs;
  int maxLatencyMs;
  double errorRate;

  final _rng = Random();

  Future<void> _sleep() async {
    final minMs = minLatencyMs.clamp(0, maxLatencyMs);
    final maxMs = maxLatencyMs >= minMs ? maxLatencyMs : minMs;
    final dur = minMs + _rng.nextInt((maxMs - minMs + 1));
    if (dur > 0) await Future.delayed(Duration(milliseconds: dur));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await _sleep();
    if (_rng.nextDouble() < errorRate) {
      handler.reject(DioException(requestOptions: options, type: DioExceptionType.connectionError, error: 'Chaos injected error'));
      return;
    }
    handler.next(options);
  }
}
