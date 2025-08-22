
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/notifications/data/notifications_models.dart';
import 'package:sonamak_flutter/features/notifications/data/notifications_repository.dart';

class NotificationsState {
  final bool loading;
  final List<NotificationItem> items;
  final int unreadCount;
  final Object? error;
  const NotificationsState({required this.loading, this.items = const [], this.unreadCount = 0, this.error});
  factory NotificationsState.initial() => const NotificationsState(loading: false);
}

class NotificationsController extends ChangeNotifier {
  NotificationsController(this._repo);
  final NotificationsRepository _repo;

  NotificationsState _state = NotificationsState.initial();
  NotificationsState get state => _state;

  Future<void> load() async {
    _state = const NotificationsState(loading: true);
    notifyListeners();
    try {
      final list = await _repo.list();
      final unread = list.where((n) => !n.read).length;
      _state = NotificationsState(loading: false, items: list, unreadCount: unread);
      notifyListeners();
    } catch (e) {
      _state = NotificationsState(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<bool> markAllRead() async {
    try {
      await _repo.markAllRead();
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}
