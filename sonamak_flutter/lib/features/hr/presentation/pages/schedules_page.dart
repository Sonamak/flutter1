import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/hr/data/hr_models.dart';
import 'package:sonamak_flutter/features/hr/data/hr_repository.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  final _repo = HrRepository();
  List<ScheduleItem> _items = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _repo.appointments();
    if (!mounted) return;
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Schedules')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final s = _items[i];
            // ✅ start/end are Strings (see hr_models.ScheduleItem)
            final time = '${s.start} → ${s.end}';
            final status = (s.status ?? '').isNotEmpty ? ' • ${s.status}' : '';
            return ListTile(
              title: Text(s.title),
              subtitle: Text('$time$status'),
            );
          },
        ),
      ),
    );
  }
}
