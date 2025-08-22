import 'package:flutter/widgets.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/booking/presentation/pages/booking_calendar_page.dart';

/// Registers Booking feature routes (no unsupported named params).
class BookingInstaller {
  static void install() {
    RouteHub.register('/booking/calendar', const RouteEntry(builder: _calendar));
  }

  static Widget _calendar(BuildContext context) => const BookingCalendarPage();
}
