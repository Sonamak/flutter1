import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/booking/data/booking_repository.dart';

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});
  @override
  State<BookingCalendarPage> createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  final repo = BookingRepository();
  List<Speciality> _specialities = const [];
  List<DoctorLite> _doctors = const [];
  bool _loading = false;
  int? _branchId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final specs = await repo.fetchSpecialities();
    final docs = await repo.fetchDoctorsRaw(branchId: _branchId);
    if (!mounted) return;
    setState(() { _specialities = specs; _doctors = docs; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Booking Calendar')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(children: [
                DropdownButton<int?>(
                  value: _branchId,
                  hint: const Text('Branch'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All branches')),
                    DropdownMenuItem(value: 1, child: Text('Branch 1')),
                    DropdownMenuItem(value: 2, child: Text('Branch 2')),
                  ],
                  onChanged: (v) => setState(() => _branchId = v),
                ),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _load, child: const Text('Refresh')),
              ]),
              const SizedBox(height: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ListTile(title: Text('Specialities')),
                            const Divider(height: 1),
                            Expanded(child: ListView.builder(
                              itemCount: _specialities.length,
                              itemBuilder: (_, i) => ListTile(title: Text(_specialities[i].name)),
                            )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ListTile(title: Text('Doctors')),
                            const Divider(height: 1),
                            Expanded(child: ListView.builder(
                              itemCount: _doctors.length,
                              itemBuilder: (_, i) => ListTile(title: Text(_doctors[i].name)),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
