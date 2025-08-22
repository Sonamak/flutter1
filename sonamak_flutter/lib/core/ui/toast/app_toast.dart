import 'package:flutter/material.dart';

class AppToast {
  static void show(BuildContext context, String message, {bool error=false, Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      duration: duration,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void success(BuildContext context, String message) => show(context, message, error: false);
  static void error(BuildContext context, String message) => show(context, message, error: true);
}
