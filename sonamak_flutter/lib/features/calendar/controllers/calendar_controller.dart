
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/shared/calendar/models.dart';
import 'package:sonamak_flutter/shared/calendar/models_ext.dart';

class CalendarState {
  final DateTime anchor;
  final List<CalendarEvent> events;
  final bool loading;
  final Object? error;

  const CalendarState({required this.anchor, this.events = const [], this.loading = false, this.error});

  CalendarState copyWith({DateTime? anchor, List<CalendarEvent>? events, bool? loading, Object? error}) {
    return CalendarState(
      anchor: anchor ?? this.anchor,
      events: events ?? this.events,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  factory CalendarState.initial() {
    final now = DateTime.now();
    return CalendarState(anchor: DateTime(now.year, now.month, now.day));
  }
}

class CalendarController extends ChangeNotifier {
  CalendarController();

  CalendarState _state = CalendarState.initial();
  CalendarState get state => _state;

  void setAnchor(DateTime d) {
    _state = _state.copyWith(anchor: d);
    notifyListeners();
  }

  Future<void> loadInitial() async {
    _state = _state.copyWith(loading: true, error: null);
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final now = _state.anchor;
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final rnd = Random(42);
    final colors = <Color>[const Color(0xFF2E7D32), const Color(0xFF1565C0), const Color(0xFF6A1B9A), const Color(0xFFEF6C00)];
    final items = <CalendarEvent>[];
    for (int d = 0; d < 5; d++) {
      for (int i = 0; i < 3; i++) {
        final day = startOfWeek.add(Duration(days: d));
        final h = 9 + rnd.nextInt(6);
        final start = DateTime(day.year, day.month, day.day, h, 0);
        final end = start.add(const Duration(minutes: 30));
        items.add(CalendarEvent(
          id: 'evt_${d}_$i',
          start: start,
          end: end,
          title: 'Appointment #${d + 1}.$i',
          subtitle: 'Room ${(i % 3) + 1}',
          color: colors[(d + i) % colors.length],
        ));
      }
    }
    _state = _state.copyWith(loading: false, events: items);
    notifyListeners();
  }

  void addAppointment(CalendarEvent e) {
    final list = List<CalendarEvent>.from(_state.events)..add(e);
    _state = _state.copyWith(events: list);
    notifyListeners();
  }

  void moveEvent(String id, DateTime newStart) {
    final list = _state.events.map((e) {
      if (e.id != id) return e;
      final duration = e.end.difference(e.start);
      return e.copyWith(start: newStart, end: newStart.add(duration));
    }).toList(growable: false);
    _state = _state.copyWith(events: list);
    notifyListeners();
  }

  void resizeEvent(String id, {DateTime? newStart, DateTime? newEnd}) {
    final list = _state.events.map((e) {
      if (e.id != id) return e;
      DateTime s = newStart ?? e.start;
      DateTime en = newEnd ?? e.end;
      if (!s.isBefore(en)) {
        en = s.add(const Duration(minutes: 15));
      }
      return e.copyWith(start: s, end: en);
    }).toList(growable: false);
    _state = _state.copyWith(events: list);
    notifyListeners();
  }
}
