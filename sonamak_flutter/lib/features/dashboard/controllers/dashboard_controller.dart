import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/dashboard/data/dashboard_repository.dart';

class DashboardState {
  final bool loadingQueue;
  final bool loadingPayments;
  final List<Map<String, dynamic>> queue;
  final List<Map<String, dynamic>> payments;
  final Object? error;

  const DashboardState({
    required this.loadingQueue,
    required this.loadingPayments,
    this.queue = const [],
    this.payments = const [],
    this.error,
  });

  factory DashboardState.initial() => const DashboardState(loadingQueue: false, loadingPayments: false);

  DashboardState copyWith({
    bool? loadingQueue,
    bool? loadingPayments,
    List<Map<String, dynamic>>? queue,
    List<Map<String, dynamic>>? payments,
    Object? error,
  }) {
    return DashboardState(
      loadingQueue: loadingQueue ?? this.loadingQueue,
      loadingPayments: loadingPayments ?? this.loadingPayments,
      queue: queue ?? this.queue,
      payments: payments ?? this.payments,
      error: error,
    );
  }
}

class DashboardController extends ChangeNotifier {
  DashboardController(this._repo);
  final DashboardRepository _repo;

  DashboardState _state = DashboardState.initial();
  DashboardState get state => _state;

  Future<void> loadQueue({int? branchId}) async {
    _state = _state.copyWith(loadingQueue: true, error: null);
    notifyListeners();
    try {
      final items = await _repo.getQueue(branchId: branchId);
      _state = _state.copyWith(loadingQueue: false, queue: items);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loadingQueue: false, error: e);
      notifyListeners();
    }
  }

  Future<void> loadPayments({int? branchId, String? date}) async {
    _state = _state.copyWith(loadingPayments: true, error: null);
    notifyListeners();
    try {
      final items = await _repo.getPayments(branchId: branchId, date: date);
      _state = _state.copyWith(loadingPayments: false, payments: items);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loadingPayments: false, error: e);
      notifyListeners();
    }
  }

  Future<void> clearPayment(Map<String, dynamic> body) async {
    await _repo.clearPayment(body);
    await loadPayments();
  }

  Future<void> updateQueue(Map<String, dynamic> body) async {
    await _repo.updateQueue(body);
    await loadQueue();
  }

  Future<void> manualQueue(Map<String, dynamic> body) async {
    await _repo.manualQueue(body);
    await loadQueue();
  }

  Future<void> moveLine(Map<String, dynamic> body) async {
    await _repo.moveLine(body);
    await loadQueue();
  }
}
