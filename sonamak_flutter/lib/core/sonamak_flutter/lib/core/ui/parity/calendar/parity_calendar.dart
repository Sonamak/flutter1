
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sonamak_flutter/shared/calendar/models.dart';

enum CalendarView { week, day }

class ParityCalendar extends StatefulWidget {
  const ParityCalendar({
    super.key,
    required this.anchor,
    required this.events,
    this.minuteStep = 30,
    this.dayStartHour = 8,
    this.dayEndHour = 18,
    this.view = CalendarView.week,
    this.onSlotTap,
    this.onEventTap,
    this.onEventMoved,
    this.onEventResized,
  });

  final DateTime anchor;
  final List<CalendarEvent> events;
  final int minuteStep;
  final int dayStartHour;
  final int dayEndHour;
  final CalendarView view;

  final ValueChanged<DateTime>? onSlotTap;
  final ValueChanged<CalendarEvent>? onEventTap;
  final void Function(String id, DateTime newStart, DateTime newEnd)? onEventMoved;
  final void Function(String id, DateTime newStart, DateTime newEnd)? onEventResized;

  @override
  State<ParityCalendar> createState() => _ParityCalendarState();
}

class _ParityCalendarState extends State<ParityCalendar> {
  static const double _headerHeight = 41;
  static const double _timeGutterWidth = 64;
  static const double _slotHeight = 48;

  late DateTime _startOfWeek;
  late List<DateTime> _days;
  late int _slotsPerDay;

  @override
  void initState() {
    super.initState();
    _recompute();
  }

  @override
  void didUpdateWidget(covariant ParityCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.anchor != widget.anchor ||
        oldWidget.minuteStep != widget.minuteStep ||
        oldWidget.dayStartHour != widget.dayStartHour ||
        oldWidget.dayEndHour != widget.dayEndHour ||
        oldWidget.view != widget.view) {
      _recompute();
    }
  }

  void _recompute() {
    final a = widget.anchor;
    _startOfWeek = DateTime(a.year, a.month, a.day).subtract(Duration(days: a.weekday - 1));
    final count = widget.view == CalendarView.week ? 7 : 1;
    _days = List<DateTime>.generate(count, (i) => (widget.view == CalendarView.week ? _startOfWeek : DateTime(a.year, a.month, a.day)).add(Duration(days: i)));
    _slotsPerDay = ((widget.dayEndHour - widget.dayStartHour) * 60 ~/ widget.minuteStep);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Header bar — blue cells like website
        SizedBox(
          height: _headerHeight,
          child: Row(
            children: [
              const SizedBox(width: _timeGutterWidth),
              Expanded(
                child: Row(
                  children: List.generate(_days.length, (i) {
                    final d = _days[i];
                    final dayName = DateFormat('EEE').format(d).toUpperCase();
                    final label = '$dayName\n${DateFormat('d').format(d)}';
                    return Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: i == (_days.length - 1) ? const Color(0xFF00BBD5) : const Color(0xFF0B56B8),
                        ),
                        child: Text(label, textAlign: TextAlign.center, style: theme.textTheme.labelSmall?.copyWith(color: Colors.white)),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        // Grid body
        Expanded(
          child: Row(
            children: [
              _buildTimeGutter(theme),
              Expanded(
                child: Row(children: List.generate(_days.length, (col) {
                  final day = _days[col];
                  final events = widget.events.where((e) => _sameDay(e.start, day)).toList();
                  return Expanded(child: _DayColumn(
                    day: day,
                    minuteStep: widget.minuteStep,
                    dayStartHour: widget.dayStartHour,
                    dayEndHour: widget.dayEndHour,
                    slotHeight: _slotHeight,
                    events: events,
                    onSlotTap: widget.onSlotTap,
                    onEventTap: widget.onEventTap,
                    onEventMoved: widget.onEventMoved,
                    onEventResized: widget.onEventResized,
                  ));
                })),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeGutter(ThemeData theme) {
    return SizedBox(
      width: _timeGutterWidth,
      child: ListView.builder(
        itemExtent: _slotHeight,
        itemCount: _slotsPerDay,
        itemBuilder: (context, i) {
          final mins = i * widget.minuteStep;
          final hour = widget.dayStartHour + (mins ~/ 60);
          final minute = mins % 60;
          final label = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
          return Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 6),
            child: Text(label, style: theme.textTheme.bodySmall),
          );
        },
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.minuteStep,
    required this.dayStartHour,
    required this.dayEndHour,
    required this.slotHeight,
    required this.events,
    required this.onSlotTap,
    required this.onEventTap,
    required this.onEventMoved,
    required this.onEventResized,
  });

  final DateTime day;
  final int minuteStep;
  final int dayStartHour;
  final int dayEndHour;
  final double slotHeight;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime>? onSlotTap;
  final ValueChanged<CalendarEvent>? onEventTap;
  final void Function(String id, DateTime newStart, DateTime newEnd)? onEventMoved;
  final void Function(String id, DateTime newStart, DateTime newEnd)? onEventResized;

  @override
  Widget build(BuildContext context) {
    final totalSlots = ((dayEndHour - dayStartHour) * 60 ~/ minuteStep);
    final dayStart = DateTime(day.year, day.month, day.day, dayStartHour);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) {
        final y = d.localPosition.dy;
        final minutesFromStart = (y / slotHeight) * minuteStep;
        final snapped = (minutesFromStart / minuteStep).floor() * minuteStep;
        final start = dayStart.add(Duration(minutes: snapped));
        onSlotTap?.call(start);
      },
      child: Stack(
        children: [
          ListView.builder(
            itemExtent: slotHeight,
            itemCount: totalSlots,
            itemBuilder: (context, i) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0x1A000000))),
                ),
              );
            },
          ),
          ...events.map((e) {
            final topMinutes = e.start.difference(dayStart).inMinutes;
            final heightMinutes = e.end.difference(e.start).inMinutes;
            final top = (topMinutes / minuteStep) * slotHeight;
            final height = math.max(slotHeight / 2, (heightMinutes / minuteStep) * slotHeight);
            return Positioned(
              left: 6, right: 6, top: top, height: height,
              child: _EventTile(event: e, onTap: onEventTap, onMoved: onEventMoved, onResized: onEventResized, day: day),
            );
          }),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event, required this.onTap, required this.onMoved, required this.onResized, required this.day});
  final CalendarEvent event;
  final ValueChanged<CalendarEvent>? onTap;
  final void Function(String id, DateTime newStart, DateTime newEnd)? onMoved;
  final void Function(String id, DateTime newStart, DateTime newEnd)? onResized;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: event.color.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: event.color.withValues(alpha: 0.6), width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () => onTap?.call(event),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (event.subtitle != null && event.subtitle!.isNotEmpty)
                Text(
                  event.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
