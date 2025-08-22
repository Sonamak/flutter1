
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/ui/parity/data_grid/parity_data_table.dart';
import 'package:sonamak_flutter/features/finance/data/finance_models.dart';
import 'package:sonamak_flutter/features/finance/data/finance_repository.dart';

/// Finance — Transactions (parity table)
///
/// Uses ParityDataTable to provide quick filter, density presets, column resize,
/// sticky header, and paging. Server fetch falls back to repository `allTransactions()`
/// and performs client-side paging to avoid coupling to an unstable filter endpoint.
class FinanceTransactionsPage extends StatefulWidget {
  const FinanceTransactionsPage({super.key});

  @override
  State<FinanceTransactionsPage> createState() => _FinanceTransactionsPageState();
}

class _FinanceTransactionsPageState extends State<FinanceTransactionsPage> {
  final _repo = FinanceRepository();

  Future<ParityServerPage<FinanceRow>> _fetch(ParityServerQuery q) async {
    final (rows, _incomes) = await _repo.allTransactions();
    // Apply quick filter client-side if present
    final data = q.quickFilter == null || q.quickFilter!.trim().isEmpty
        ? rows
        : rows.where((r) {
            final s = r.raw.values.map((v) => '$v'.toLowerCase()).join(' • ');
            return s.contains(q.quickFilter!.toLowerCase());
          }).toList(growable: false);
    // naive paging
    final start = (q.page - 1) * q.pageSize;
    final end = (start + q.pageSize).clamp(0, data.length);
    final pageRows = (start >= 0 && start < data.length) ? data.sublist(start, end) : <FinanceRow>[];
    return ParityServerPage<FinanceRow>(rows: pageRows, total: data.length);
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Finance — Transactions')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: ParityDataTable<FinanceRow>(
            fetch: _fetch,
            density: ParityTableDensity.standard,
            quickFilterPlaceholder: 'Search transactions…',
            columns: const [
              ParityColumnSpec<FinanceRow>(key: 'date', title: 'Date', width: 140, sortable: true),
              ParityColumnSpec<FinanceRow>(key: 'event', title: 'Event', width: 220, sortable: true),
              ParityColumnSpec<FinanceRow>(key: 'amount', title: 'Amount', width: 120, align: Alignment.centerRight, sortable: true),
              ParityColumnSpec<FinanceRow>(key: 'user', title: 'User', width: 180),
            ],
            rowBuilder: (context, row, widths) {
              final raw = row.raw;
              String pickFirst(List<String> keys) {
                for (final k in keys) {
                  final v = raw[k];
                  if (v != null && '$v'.trim().isNotEmpty) return '$v';
                }
                return '';
              }
              final date = pickFirst(['date', 'created_at', 'updated_at']);
              final event = pickFirst(['event', 'type', 'text', 'description']);
              final amount = pickFirst(['amount', 'paid', 'total_amount', 'value', 'price']);
              final user = pickFirst(['user', 'created_by', 'staff', 'member', 'doctor']);
              final cells = [date, event, amount, user];
              return SizedBox(
                height: 48,
                child: Row(children: List.generate(cells.length, (i) {
                  return SizedBox(
                    width: widths[i],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: i == 2 ? Alignment.centerRight : Alignment.centerLeft,
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
