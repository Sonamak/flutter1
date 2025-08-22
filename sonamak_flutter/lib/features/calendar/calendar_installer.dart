
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/calendar/presentation/pages/calendar_page.dart';

class CalendarInstaller {
  static void register() {
    RouteHub.register('/admin/calendar', RouteEntry(builder: (_) => const CalendarPage()));
  }
}
