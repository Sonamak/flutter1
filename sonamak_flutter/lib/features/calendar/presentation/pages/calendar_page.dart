
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/app/admin/widgets/admin_top_nav.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/calendar/controllers/calendar_controller.dart';
import 'package:sonamak_flutter/shared/calendar/add_appointment_form.dart';
import 'package:sonamak_flutter/shared/calendar/models.dart';
import 'package:sonamak_flutter/core/ui/parity/calendar/parity_calendar.dart';
import 'package:sonamak_flutter/features/setup/branches/branch_selector.dart';
import 'package:sonamak_flutter/features/setup/branches/server_branch_source.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController controller = CalendarController();
  CalendarView _view = CalendarView.week;
  DateTime _anchor = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller.loadInitial();
  }

  void _shiftWeek(int delta) {
    setState(() => _anchor = _anchor.add(Duration(days: 7 * delta)));
  }

  @override
  Widget build(BuildContext context) {
    final rangeLabel = _weekLabel(_anchor);
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Calendar')),
        body: Column(children:[const AdminTopNav(active: 'Bookings'), Expanded(child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title row + CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Center Appointment Calendar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      FilledButton(
                        onPressed: () => _openCreate(DateTime.now()),
                        child: const Text('Add New Appointment'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filters row (Refresh, Branch, Doctor toggle) + View segment + Week nav label
                  Wrap(
                    spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      OutlinedButton.icon(onPressed: () => controller.loadInitial(), icon: const Icon(Icons.refresh), label: const Text('Refresh Calendar')),
                      BranchSelector(dataSource: ServerBranchSource()),
                      FilterChip(
                        label: const Text('Doctor Calendar'),
                        selected: true,
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: 12),
                      SegmentedButton<CalendarView>(
                        segments: const [
                          ButtonSegment(value: CalendarView.week, label: Text('Week')),
                          ButtonSegment(value: CalendarView.day, label: Text('Day')),
                        ],
                        selected: {_view},
                        onSelectionChanged: (s) => setState(() => _view = s.first),
                      ),
                      const Spacer(),
                      IconButton(onPressed: () => _shiftWeek(-1), icon: const Icon(Icons.chevron_left)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(8)),
                        child: Text(rangeLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      IconButton(onPressed: () => _shiftWeek(1), icon: const Icon(Icons.chevron_right)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: st.loading
                        ? const Center(child: CircularProgressIndicator())
                        : ParityCalendar(
                            anchor: _anchor,
                            view: _view,
                            events: st.events,
                            onSlotTap: (start) => _openCreate(start),
                            onEventTap: (_) {},
                            onEventMoved: (id, s, e) => controller.resizeEvent(id, newStart: s, newEnd: e),
                            onEventResized: (id, s, e) => controller.resizeEvent(id, newStart: s, newEnd: e),
                          ),
                  ),
                ],
              ),
            );
          },
        ),),],),
      ),
    );
  }

  String _weekLabel(DateTime anchor) {
    final start = anchor.subtract(Duration(days: anchor.weekday - 1));
    final end = start.add(const Duration(days: 6));
    final startLbl = DateFormat("MMM d").format(start).toUpperCase();
    final endLbl = DateFormat("MMM d").format(end).toUpperCase();
    return "$startLbl - $endLbl";
  }

  Future<void> _openCreate(DateTime start) async {
    final created = await showDialog<CalendarEvent?>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AddAppointmentForm(
              initialDate: start,
              onSubmit: (data) {
                final dur = (data['duration'] as int?) ?? 30;
                final name = (data['name'] as String?) ?? 'New';
                final phone = (data['phone'] as String?) ?? '';
                final startIso = data['start']?.toString() ?? start.toIso8601String();
                final s = DateTime.tryParse(startIso) ?? start;
                final e = s.add(Duration(minutes: dur));
                Navigator.of(context).pop(CalendarEvent(id: 'new_${DateTime.now().millisecondsSinceEpoch}', start: s, end: e, title: name, subtitle: phone, color: const Color(0xFF1565C0)));
              },
            ),
          ),
        );
      },
    );
    if (created != null) {
      controller.addAppointment(created);
      if (mounted) AppSnackbar.showSuccess(context, 'Added "${created.title}"');
    }
  }
}
