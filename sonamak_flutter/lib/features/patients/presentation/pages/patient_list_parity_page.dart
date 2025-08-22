
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/ui/parity/data_grid/parity_data_table.dart';
import 'package:sonamak_flutter/features/patients/data/patient_models.dart';
import 'package:sonamak_flutter/features/patients/data/patient_repository.dart';

/// Patients — List (parity table)
///
/// Replaces the plain ListView with a server-style grid that supports
/// quick filter, column resize, density, and paging (client-side).
class PatientListParityPage extends StatefulWidget {
  const PatientListParityPage({super.key});

  @override
  State<PatientListParityPage> createState() => _PatientListParityPageState();
}

class _PatientListParityPageState extends State<PatientListParityPage> {
  final _repo = PatientRepository();

  Future<ParityServerPage<PatientLite>> _fetch(ParityServerQuery q) async {
    // Always fetch all for now (no server paging in repository), then page locally.
    final list = await _repo.listAll();
    final filtered = (q.quickFilter == null || q.quickFilter!.trim().isEmpty)
        ? list
        : list.where((p) {
            final s = ('${p.id} ${p.name} ${p.phone ?? ''}').toLowerCase();
            return s.contains(q.quickFilter!.toLowerCase());
          }).toList(growable: false);
    final start = (q.page - 1) * q.pageSize;
    final end = (start + q.pageSize).clamp(0, filtered.length);
    final pageRows = (start >= 0 && start < filtered.length) ? filtered.sublist(start, end) : <PatientLite>[];
    return ParityServerPage<PatientLite>(rows: pageRows, total: filtered.length);
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Patients')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: ParityDataTable<PatientLite>(
            fetch: _fetch,
            columns: const [
              ParityColumnSpec<PatientLite>(key: 'id', title: 'ID', width: 80, align: Alignment.centerRight, sortable: true),
              ParityColumnSpec<PatientLite>(key: 'name', title: 'Name', width: 240, sortable: true),
              ParityColumnSpec<PatientLite>(key: 'phone', title: 'Phone', width: 180),
            ],
            rowBuilder: (context, row, widths) {
              final cells = ['${row.id}', row.name, row.phone ?? ''];
              return SizedBox(
                height: 44,
                child: Row(children: List.generate(cells.length, (i) {
                  return SizedBox(
                    width: widths[i],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: i == 0 ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          cells[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  );
                })),
              );
            },
          ),
        ),
      ),
    );
  }
}
