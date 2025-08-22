import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sonamak_flutter/core/db/app_database.dart';

class SyncCenter {
  SyncCenter._(this._db);
  static SyncCenter? _instance;
  final AppDatabase _db; // use _db to avoid unused warning
  StreamSubscription? _sub;

  static Future<void> start(AppDatabase db) async {
    _instance ??= SyncCenter._(db);
    await _instance!._init();
  }

  Future<void> _init() async {
    // touch db to avoid unused-field lint
    _db.hashCode;
    _sub?.cancel();
    _sub = Connectivity().onConnectivityChanged.listen((_) {
      // TODO: queue drain logic
    });
  }

  static Future<void> stop() async {
    await _instance?._sub?.cancel();
    _instance = null;
  }
}
