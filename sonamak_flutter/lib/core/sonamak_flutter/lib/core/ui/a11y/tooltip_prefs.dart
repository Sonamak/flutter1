
import 'package:flutter/material.dart';

/// Centralized tooltip timings to keep behavior consistent with the web.
class TooltipPrefs {
  static const Duration wait = Duration(milliseconds: 300);
  static const Duration show = Duration(seconds: 3);

  static Tooltip wrap({required String message, required Widget child}) {
    return Tooltip(message: message, waitDuration: wait, showDuration: show, child: child);
  }
}
