
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/app/admin/widgets/admin_top_nav.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/dashboard/controllers/dashboard_controller.dart';
import 'package:sonamak_flutter/features/dashboard/data/dashboard_repository.dart';
import 'package:sonamak_flutter/features/dashboard/presentation/widgets/kpi_card.dart';
import 'package:sonamak_flutter/features/dashboard/presentation/widgets/center_bookings_panel.dart';
import 'package:sonamak_flutter/features/dashboard/week_header/week_header.dart';
import 'package:sonamak_flutter/features/finance/data/finance_api.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController _controller = DashboardController(const DashboardRepository());
  DateTime _anchor = DateTime.now();
  int? _branchId;
  int _patients = 0, _income = 0, _bookings = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  dynamic _unwrap(dynamic v) {
    if (v == null) return null;
    dynamic x = v;
    if (x is String) { try { x = jsonDecode(x); } catch (_) {} }
    if (x is Map) {
      if (x.containsKey('payload')) return _unwrap(x['payload']);
      if (x.containsKey('data')) return _unwrap(x['data']);
      if (x.containsKey('rows')) return _unwrap(x['rows']);
      return x;
    }
    return x;
  }

  int _num(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is String) { final s = v.replaceAll(RegExp(r'[^\d-]'), ''); return int.tryParse(s) ?? 0; }
    return 0;
  }

  Future<void> _load() async {
    await _controller.loadQueue(branchId: _branchId);
    final dateStr = DateFormat('yyyy-MM-dd').format(_anchor);
    await _controller.loadPayments(branchId: _branchId, date: dateStr);
    try {
      final Response<Map<String, dynamic>> res = await FinanceApi.dashboard();
      final body = _unwrap(res.data);
      _patients = _num(body?['total_patients'] ?? body?['patients_count'] ?? body?['patients']);
      _income = _num(body?['total_income'] ?? body?['income']);
      _bookings = _num(body?['total_bookings'] ?? body?['bookings']);
    } catch (_) {
      _patients = _income = _bookings = 0;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: Column(
          children: [
            const AdminTopNav(active: 'Dashboard'),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final width = MediaQuery.of(context).size.width;
                  final twoCols = width >= 1100;

                  final leftChildren = <Widget>[
                    WeekHeader(anchor: _anchor, onSelect: (d) { setState(() => _anchor = d); _load(); }),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: KpiCard(
                          title: 'Total Patients',
                          value: NumberFormat.decimalPattern().format(_patients),
                          deltaLabel: '-19.59% Month',
                          gradient: const LinearGradient(colors: [Color(0xFFFFF4F2), Color(0xFFFFE9E4)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: KpiCard(
                          title: 'Total Income',
                          value: NumberFormat.decimalPattern().format(_income),
                          suffix: ' EGP',
                          gradient: const LinearGradient(colors: [Color(0xFFE6F0FF), Color(0xFFDDEBFF)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                          valueColor: const Color(0xFF0F172A),
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: KpiCard(
                          title: 'Total Booking',
                          value: NumberFormat.decimalPattern().format(_bookings),
                          gradient: const LinearGradient(colors: [Color(0xFFFFF4F2), Color(0xFFFFE9E4)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _action('Calendar', Icons.calendar_month, '/admin/calendar')),
                        const SizedBox(width: 12),
                        Expanded(child: _action('Patients', Icons.group, '/admin/patients')),
                        const SizedBox(width: 12),
                        Expanded(child: _action('Members', Icons.people_alt_outlined, '/admin/members')),
                        const SizedBox(width: 12),
                        Expanded(child: _action('Lab', Icons.science_outlined, '/admin/lab')),
                        const SizedBox(width: 12),
                        Expanded(child: _action('Store', Icons.store_mall_directory_outlined, '/admin/store')),
                        const SizedBox(width: 12),
                        Expanded(child: _action('Finance', Icons.receipt_long_outlined, '/admin/finance')),
                      ],
                    ),
                  ];

                  final left = ListView(padding: const EdgeInsets.all(16), children: leftChildren);
                  final right = Padding(padding: const EdgeInsets.all(16), child: CenterBookingsPanel(anchor: _anchor));

                  if (twoCols) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: left),
                        const VerticalDivider(width: 1),
                        Expanded(flex: 2, child: right),
                      ],
                    );
                  }
                  return ListView(children: [const SizedBox(height: 8), ...leftChildren, right]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(String label, IconData icon, String path) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).pushNamed(path),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon), const SizedBox(width: 8), Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}
