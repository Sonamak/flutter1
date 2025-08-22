import 'package:sonamak_flutter/core/db/app_database.dart';

class DbInit {
  static AppDatabase? _db;
  static AppDatabase get db => _db ??= AppDatabase.I;

  static Future<void> ensure() async {
    await db.open();
  }
}
