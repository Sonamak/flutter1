
import 'package:flutter/material.dart';

/// Range/date pickers with presets similar to MUI.
/// These wrappers centralize UX parity (labels, actions).
class ParityDatePickers {
  static Future<DateTimeRange?> pickRange({
    required BuildContext context,
    DateTimeRange? initial,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final now = DateTime.now();
    return showDateRangePicker(
      context: context,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
      initialDateRange: initial,
      saveText: 'Apply',
      helpText: 'Select range',
    );
  }

  static Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initial,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
      helpText: 'Select date',
    );
  }
}
