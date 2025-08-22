
import 'package:flutter/material.dart';

class CalendarEvent {
  final String id;
  final DateTime start;
  final DateTime end;
  final String title;
  final String? subtitle;
  final Color color;

  const CalendarEvent({
    required this.id,
    required this.start,
    required this.end,
    required this.title,
    this.subtitle,
    this.color = const Color(0xFF1976D2),
  });
}
