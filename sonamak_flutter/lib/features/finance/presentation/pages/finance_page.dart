
// Rebuilt to fix parameter mismatch and type errors in onApply call.
// Keeps public API stable: FinancePage, _Filters and onApply signature.
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/finance/controllers/finance_controller.dart';
import 'package:sonamak_flutter/features/finance/data/finance_models.dart';
import 'package:sonamak_flutter/features/finance/data/finance_repository.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  late final FinanceController controller;

  @override
  void initState() {
    super.initState();
    controller = FinanceController(FinanceRepository())..bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Financial Transactions')),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final s = controller.state;
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Filters(
                    branches: s.branches,
                    onApply: (String? event, String? date, String? filter, int? branchId, int? isVisa, int? visit) async {
                      await controller.setFilters(
                        event: event,
                        date: date,
                        filter: filter,
                        branchId: branchId,
                        isVisa: isVisa,
                        visit: visit,
                      );
                      
                    },
                  ),
                  const SizedBox(height: 12),
                  if (s.loading) const LinearProgressIndicator(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: s.rows.length,
                      itemBuilder: (context, i) {
                        final row = s.rows[i];
                        return Card(
                          child: ListTile(
                            title: Text('Row \${i + 1}'),
                            subtitle: Text(row.toString()),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Filters extends StatefulWidget {
  const _Filters({required this.branches, required this.onApply});
  final List<BranchItem> branches;
  // NOTE: Signature must match callers: 6 positional args
  final void Function(String? event, String? date, String? filter, int? branchId, int? isVisa, int? visit) onApply;

  @override
  State<_Filters> createState() => _FiltersState();
}

class _FiltersState extends State<_Filters> {
  final _event = TextEditingController();
  final _date = TextEditingController();
  final _filter = TextEditingController();
  int? _branchId;
  int? _isVisa;
  int? _visit;

  @override
  void dispose() {
    _event.dispose();
    _date.dispose();
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Event
          SizedBox(
            width: 200,
            child: TextField(
              controller: _event,
              decoration: const InputDecoration(labelText: 'Event', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 8),
          // Date
          SizedBox(
            width: 170,
            child: TextField(
              controller: _date,
              decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 8),
          // Filter
          SizedBox(
            width: 180,
            child: TextField(
              controller: _filter,
              decoration: const InputDecoration(labelText: 'Filter', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 8),
          // Branch
          DropdownButton<int?>(
            value: _branchId,
            items: <DropdownMenuItem<int?>>[
              const DropdownMenuItem(value: null, child: Text('All branches')),
              ...widget.branches.map((b) => DropdownMenuItem<int?>(value: b.id, child: Text(b.name))),
            ],
            onChanged: (v) => setState(() => _branchId = v),
          ),
          const SizedBox(width: 8),
          // Visa?
          DropdownButton<int?>(
            value: _isVisa,
            items: const [
              DropdownMenuItem(value: null, child: Text('Payment: any')),
              DropdownMenuItem(value: 0, child: Text('Cash')),
              DropdownMenuItem(value: 1, child: Text('Visa')),
            ],
            onChanged: (v) => setState(() => _isVisa = v),
          ),
          const SizedBox(width: 8),
          // Visit?
          DropdownButton<int?>(
            value: _visit,
            items: const [
              DropdownMenuItem(value: null, child: Text('Visit? any')),
              DropdownMenuItem(value: 0, child: Text('No')),
              DropdownMenuItem(value: 1, child: Text('Yes')),
            ],
            onChanged: (v) => setState(() => _visit = v),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              final event = _event.text.trim().isEmpty ? null : _event.text.trim();
              final date = _date.text.trim().isEmpty ? null : _date.text.trim();
              final filter = _filter.text.trim().isEmpty ? null : _filter.text.trim();
              // Pass exactly 6 positional args with correct types:
              widget.onApply(event, date, filter, _branchId, _isVisa, _visit);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
