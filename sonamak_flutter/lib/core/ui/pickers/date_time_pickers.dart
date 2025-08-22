import 'package:flutter/material.dart';

class DateTimePickers {
  static Future<DateTime?> pickDate(BuildContext context, {DateTime? initial, DateTime? first, DateTime? last}) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: first ?? DateTime(now.year - 5),
      lastDate: last ?? DateTime(now.year + 5),
    );
  }

  static Future<TimeOfDay?> pickTime(BuildContext context, {TimeOfDay? initial}) {
    return showTimePicker(context: context, initialTime: initial ?? TimeOfDay.now());
  }

  static Future<DateTime?> pickDateTime(BuildContext context, {DateTime? initial}) async {
    final d = await pickDate(context, initial: initial);
    if (d == null) return null;
    final t = await pickTime(context, initial: initial != null ? TimeOfDay.fromDateTime(initial) : null);
    if (t == null) return d;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }
}
