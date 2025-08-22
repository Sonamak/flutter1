
import 'package:flutter/material.dart';
import 'models.dart';

typedef SlotTap = void Function(DateTime start);
typedef EventTap = void Function(CalendarEvent event);

class SfCalendar extends StatelessWidget {
  const SfCalendar({
    super.key,
    required this.anchor,
    required this.events,
    this.onSlotTap,
    this.onEventTap,
    this.minuteStep = 30,
    this.dayStartHour = 8,
    this.dayEndHour = 18,
  });

  final DateTime anchor;
  final List<CalendarEvent> events;
  final SlotTap? onSlotTap;
  final EventTap? onEventTap;
  final int minuteStep;
  final int dayStartHour;
  final int dayEndHour;

  @override
  Widget build(BuildContext context) {
    final startOfWeek = _startOfWeek(anchor);
    final days = List<DateTime>.generate(7, (i) => startOfWeek.add(Duration(days: i)));
    final slotsPerDay = ((dayEndHour - dayStartHour) * 60 ~/ minuteStep);

    return Column(
      children: [
        // time labels + 7 columns
        Expanded(
          child: Row(
            children: [
              // time gutter
              SizedBox(
                width: 56,
                child: ListView.builder(
                  itemCount: slotsPerDay,
                  itemBuilder: (context, i) {
                    final h = dayStartHour * 60 + i * minuteStep;
                    final hour = h ~/ 60;
                    final minute = h % 60;
                    return SizedBox(
                      height: 48,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text('${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}'),
                      ),
                    );
                  },
                ),
              ),
              // days grid
              Expanded(
                child: Row(
                  children: List.generate(7, (col) {
                    final day = days[col];
                    return Expanded(
                      child: _DayColumn(
                        day: day,
                        minuteStep: minuteStep,
                        dayStartHour: dayStartHour,
                        dayEndHour: dayEndHour,
                        events: events.where((e) => _isSameDay(e.start, day)).toList(),
                        onSlotTap: onSlotTap,
                        onEventTap: onEventTap,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static DateTime _startOfWeek(DateTime d) {
    final wd = d.weekday; // Mon=1..Sun=7
    return DateTime(d.year, d.month, d.day).subtract(Duration(days: wd - 1));
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.minuteStep,
    required this.dayStartHour,
    required this.dayEndHour,
    required this.events,
    this.onSlotTap,
    this.onEventTap,
  });

  final DateTime day;
  final int minuteStep;
  final int dayStartHour;
  final int dayEndHour;
  final List<CalendarEvent> events;
  final SlotTap? onSlotTap;
  final EventTap? onEventTap;

  @override
  Widget build(BuildContext context) {
    final slots = ((dayEndHour - dayStartHour) * 60 ~/ minuteStep);
    return ListView.builder(
      itemCount: slots,
      itemBuilder: (context, i) {
        final start = DateTime(day.year, day.month, day.day, dayStartHour).add(Duration(minutes: i * minuteStep));
        final e = _eventAt(start);
        if (e != null) {
          return GestureDetector(
            onTap: () => onEventTap?.call(e),
            child: Container(
              height: 48,
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: e.color.withAlpha(38),
                border: Border.all(color: e.color.withAlpha(128)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Align(alignment: Alignment.centerLeft, child: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ),
          );
        }
        return InkWell(
          onTap: () => onSlotTap?.call(start),
          child: Container(
            height: 48,
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      },
    );
  }

  CalendarEvent? _eventAt(DateTime slotStart) {
    for (final e in events) {
      if (!slotStart.isBefore(e.start) && slotStart.isBefore(e.end)) return e;
    }
    return null;
  }
}
