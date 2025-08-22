import 'package:flutter/material.dart';

typedef ServerFetch<T> = Future<ServerPage<T>> Function(ServerQuery query);

class ServerQuery {
  final int page; // 1-based
  final int pageSize;
  final String? sortBy;
  final bool sortAsc;
  final String? quickFilter;
  final Map<String, dynamic>? filters;

  const ServerQuery({
    required this.page,
    required this.pageSize,
    this.sortBy,
    this.sortAsc = true,
    this.quickFilter,
    this.filters,
  });

  ServerQuery copyWith({
    int? page,
    int? pageSize,
    String? sortBy,
    bool? sortAsc,
    String? quickFilter,
    Map<String, dynamic>? filters,
  }) {
    return ServerQuery(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortBy: sortBy ?? this.sortBy,
      sortAsc: sortAsc ?? this.sortAsc,
      quickFilter: quickFilter ?? this.quickFilter,
      filters: filters ?? this.filters,
    );
  }
}

class ServerPage<T> {
  final List<T> rows;
  final int total; // total rows on server
  const ServerPage({required this.rows, required this.total});
}

class ColumnSpec<T> {
  final String key;
  final String title;
  final double? width;
  final Alignment align;
  final Widget Function(BuildContext, T) cell;
  final bool sortable;

  const ColumnSpec({
    required this.key,
    required this.title,
    required this.cell,
    this.width,
    this.align = Alignment.centerLeft,
    this.sortable = false,
  });
}

class ServerDataTable<T> extends StatefulWidget {
  final ServerFetch<T> fetch;
  final List<ColumnSpec<T>> columns;
  final int initialPageSize;
  final EdgeInsets padding;
  final void Function(BuildContext, T)? onRowTap;
  final Widget? header;
  final List<int> pageSizes;

  const ServerDataTable({
    super.key,
    required this.fetch,
    required this.columns,
    this.initialPageSize = 20,
    this.padding = const EdgeInsets.all(12),
    this.onRowTap,
    this.header,
    this.pageSizes = const [10, 20, 50, 100],
  });

  @override
  State<ServerDataTable<T>> createState() => _ServerDataTableState<T>();
}

class _ServerDataTableState<T> extends State<ServerDataTable<T>> {
  late ServerQuery _q;
  bool _loading = false;
  Object? _error;
  List<T> _rows = const [];
  int _total = 0;
  String? _sortBy;
  bool _sortAsc = true;
  final _filterCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _q = ServerQuery(page: 1, pageSize: widget.initialPageSize);
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final page = await widget.fetch(_q.copyWith(sortBy: _sortBy, sortAsc: _sortAsc, quickFilter: _filterCtl.text.trim()));
      setState(() { _rows = page.rows; _total = page.total; _loading = false; });
    } catch (e) {
      setState(() { _error = e; _loading = false; });
    }
  }

  void _changeSort(String key) {
    if (_sortBy == key) { _sortAsc = !_sortAsc; } else { _sortBy = key; _sortAsc = true; }
    _q = _q.copyWith(page: 1);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = (_q.page - 1) * _q.pageSize + 1;
    final end = (_q.page * _q.pageSize).clamp(0, _total);

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.header != null) widget.header!,
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _filterCtl,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Quick filter...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _load(),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: _q.pageSize,
                onChanged: (v) {
                  if (v == null) return;
                  setState(() { _q = _q.copyWith(pageSize: v, page: 1); });
                  _load();
                },
                items: [for (final s in widget.pageSizes) DropdownMenuItem(value: s, child: Text('Page: $s'))],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildBody(context),
            ),
          ),
          const SizedBox(height: 8),
          _buildFooter(theme, start, end),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, size: 40),
          const SizedBox(height: 8),
          Text(_error.toString()),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _load, child: const Text('Retry')),
        ]),
      );
    }
    if (_rows.isEmpty) return const Center(child: Text('No data'));

    return LayoutBuilder(builder: (context, constraints) {
      final cells = <TableRow>[];
      cells.add(TableRow(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
        children: [
          for (final c in widget.columns)
            InkWell(
              onTap: c.sortable ? () => _changeSort(c.key) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(children: [
                  Expanded(child: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600))),
                  if (c.sortable && _sortBy == c.key) Icon(_sortAsc ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
                ]),
              ),
            ),
        ],
      ));
      for (final row in _rows) {
        cells.add(TableRow(children: [
          for (final c in widget.columns)
            Container(
              alignment: c.align,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: GestureDetector(onTap: widget.onRowTap != null ? () => widget.onRowTap!(context, row) : null, child: c.cell(context, row)),
            ),
        ]));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          columnWidths: {for (int i = 0; i < widget.columns.length; i++) i: widget.columns[i].width != null ? FixedColumnWidth(widget.columns[i].width!) : const IntrinsicColumnWidth()},
          border: const TableBorder.symmetric(inside: BorderSide(width: .5, color: Colors.black12)),
          children: cells,
        ),
      );
    });
  }

  Widget _buildFooter(ThemeData theme, int start, int end) {
    final pages = (_total / _q.pageSize).ceil().clamp(1, 999999);
    return Row(children: [
      Text('Showing ${_rows.isEmpty ? 0 : start}–$end of $_total'),
      const Spacer(),
      IconButton(onPressed: _q.page > 1 ? () { setState(() { _q = _q.copyWith(page: 1); }); _load(); } : null, icon: const Icon(Icons.first_page)),
      IconButton(onPressed: _q.page > 1 ? () { setState(() { _q = _q.copyWith(page: _q.page - 1); }); _load(); } : null, icon: const Icon(Icons.chevron_left)),
      Text('${_q.page}/$pages'),
      IconButton(onPressed: _q.page < pages ? () { setState(() { _q = _q.copyWith(page: _q.page + 1); }); _load(); } : null, icon: const Icon(Icons.chevron_right)),
      IconButton(onPressed: _q.page < pages ? () { setState(() { _q = _q.copyWith(page: pages); }); _load(); } : null, icon: const Icon(Icons.last_page)),
    ]);
  }
}
