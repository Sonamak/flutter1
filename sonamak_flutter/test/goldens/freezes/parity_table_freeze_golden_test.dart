
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../golden_test_config.dart';
import 'package:sonamak_flutter/core/ui/parity/data_grid/parity_data_table.dart';

class MapRow { final Map<String, dynamic> raw; MapRow(this.raw); }

Future<ParityServerPage<MapRow>> _stubFetch(ParityServerQuery q) async {
  await Future<void>.delayed(const Duration(milliseconds: 10));
  final total = 18;
  final rows = List.generate(total, (i) => MapRow({'id': i+1, 'name': 'Item $i', 'amount': (i+1)*10}));
  final start = (q.page - 1) * q.pageSize;
  final end = (start + q.pageSize).clamp(0, rows.length);
  final pageRows = (start >= 0 && start < rows.length) ? rows.sublist(start, end) : <MapRow>[];
  return ParityServerPage<MapRow>(rows: pageRows, total: total);
}

Widget _table() {
  return ParityDataTable<MapRow>(
    fetch: _stubFetch,
    columns: const [
      ParityColumnSpec<MapRow>(key: 'id', title: 'ID', width: 80, align: Alignment.centerRight, sortable: true),
      ParityColumnSpec<MapRow>(key: 'name', title: 'Name', width: 220, sortable: true),
      ParityColumnSpec<MapRow>(key: 'amount', title: 'Amount', width: 120, align: Alignment.centerRight, sortable: true),
    ],
    rowBuilder: (context, row, widths) {
      final cells = ['${row.raw['id']}', '${row.raw['name']}', '${row.raw['amount']}'];
      return Row(children: List.generate(cells.length, (i) {
        return SizedBox(width: widths[i], child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: i==0 || i==2 ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(cells[i], maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ));
      }));
    },
  );
}

void main() {
  testGoldens('ParityDataTable — rows state', (tester) async {
    await tester.pumpWidgetBuilder(SizedBox(width: 1000, height: 600, child: _table()));
    await tester.pump(const Duration(milliseconds: 30));
    await multiScreenGolden(tester, 'parity_table_rows', devices: [desktop]);
  });

  testGoldens('ParityDataTable — empty state', (tester) async {
    Future<ParityServerPage<MapRow>> empty(ParityServerQuery q) async {
      return const ParityServerPage<MapRow>(rows: <MapRow>[], total: 0);
    }
    await tester.pumpWidgetBuilder(SizedBox(
      width: 1000, height: 600,
      child: ParityDataTable<MapRow>(
        fetch: empty,
        columns: const [
          ParityColumnSpec<MapRow>(key: 'id', title: 'ID', width: 80, align: Alignment.centerRight, sortable: true),
        ],
        rowBuilder: (c, r, w) => const SizedBox.shrink(),
      ),
    ));
    await tester.pump();
    await multiScreenGolden(tester, 'parity_table_empty', devices: [desktop]);
  });

  testGoldens('ParityDataTable — error state', (tester) async {
    Future<ParityServerPage<MapRow>> err(ParityServerQuery q) async {
      throw StateError('stub failure');
    }
    await tester.pumpWidgetBuilder(SizedBox(
      width: 1000, height: 600,
      child: ParityDataTable<MapRow>(
        fetch: err,
        columns: const [
          ParityColumnSpec<MapRow>(key: 'id', title: 'ID', width: 80, align: Alignment.centerRight, sortable: true),
        ],
        rowBuilder: (c, r, w) => const SizedBox.shrink(),
      ),
    ));
    await tester.pump();
    await multiScreenGolden(tester, 'parity_table_error', devices: [desktop]);
  });
}
