
import 'package:sonamak_flutter/shared/calendar/models.dart';

extension CalendarEventCopy on CalendarEvent {
  CalendarEvent copyWith({
    String? id,
    DateTime? start,
    DateTime? end,
    String? title,
    String? subtitle,
    dynamic color, // keep dynamic so callers can pass Color without importing here
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      color: (color ?? this.color),
    );
  }
}
