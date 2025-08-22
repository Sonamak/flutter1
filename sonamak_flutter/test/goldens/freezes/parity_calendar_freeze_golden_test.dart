
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../golden_test_config.dart';
import 'package:sonamak_flutter/core/ui/parity/calendar/parity_calendar.dart';
import 'package:sonamak_flutter/shared/calendar/models.dart';

void main() {
  testGoldens('ParityCalendar — fixed week snapshot', (tester) async {
    final anchor = DateTime(2025, 8, 18);
    final events = <CalendarEvent>[
      CalendarEvent(id: 'e1', start: DateTime(2025, 8, 18, 9, 0), end: DateTime(2025, 8, 18, 9, 30), title: 'Dr. A — P1', subtitle: 'Room 1', color: const Color(0xFF1565C0)),
      CalendarEvent(id: 'e2', start: DateTime(2025, 8, 19, 10, 0), end: DateTime(2025, 8, 19, 11, 0), title: 'Dr. B — P2', subtitle: 'Room 2', color: const Color(0xFF2E7D32)),
      CalendarEvent(id: 'e3', start: DateTime(2025, 8, 20, 13, 0), end: DateTime(2025, 8, 20, 13, 30), title: 'Consultation', subtitle: 'Room 3', color: const Color(0xFF6A1B9A)),
    ];
    await tester.pumpWidgetBuilder(const SizedBox(width: 1200, height: 720, child: SizedBox()));
    await tester.pumpWidgetBuilder(SizedBox(width: 1200, height: 720, child: ParityCalendar(anchor: anchor, events: events)));
    await multiScreenGolden(tester, 'parity_calendar_week', devices: [desktop]);
  });
}
