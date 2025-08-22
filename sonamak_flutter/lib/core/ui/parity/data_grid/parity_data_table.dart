
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/ui/a11y/semantics_roles.dart';
import 'package:sonamak_flutter/core/ui/edge/empty_state.dart';
import 'package:sonamak_flutter/core/ui/edge/error_state.dart';
import 'package:sonamak_flutter/core/ui/edge/loading_state.dart';

class ParityDataTable<T> extends StatefulWidget {
  const ParityDataTable({
    super.key,
    required this.fetch,
    required this.columns,
    required this.rowBuilder,
    this.initialPageSize = 20,
    this.availablePageSizes = const [10, 20, 50, 100],
    this.quickFilterPlaceholder = 'Quick filter…',
    this.density = ParityTableDensity.standard,
    this.sortBy,
    this.sortAsc = true,
    this.toolbar,
    this.emptyBuilder,
    this.errorBuilder,
    this.cacheExtent = 600.0,
  });

  final Future<ParityServerPage<T>> Function(ParityServerQuery query) fetch;
  final List<ParityColumnSpec<T>> columns;
  final Widget Function(BuildContext context, T row, List<double> columnWidths) rowBuilder;

  final int initialPageSize;
  final List<int> availablePageSizes;
  final String quickFilterPlaceholder;

  final ParityTableDensity density;
  final String? sortBy;
  final bool sortAsc;
  final Widget? toolbar;

  final WidgetBuilder? emptyBuilder;
  final Widget Function(BuildContext context, Object error, VoidCallback retry)? errorBuilder;

  final double cacheExtent;

  @override
  State<ParityDataTable<T>> createState() => _ParityDataTableState<T>();
}

enum ParityTableDensity { compact, standard, comfortable }

class ParityServerPage<T> {
  final List<T> rows;
  final int total;
  const ParityServerPage({required this.rows, required this.total});
}

class ParityServerQuery {
  final int page; // 1-based
  final int pageSize;
  final String? sortBy;
  final bool sortAsc;
  final String? quickFilter;

  const ParityServerQuery({
    required this.page,
    required this.pageSize,
    this.sortBy,
    this.sortAsc = true,
    this.quickFilter,
  });

  ParityServerQuery copyWith({int? page, int? pageSize, String? sortBy, bool? sortAsc, String? quickFilter}) {
    return ParityServerQuery(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortBy: sortBy ?? this.sortBy,
      sortAsc: sortAsc ?? this.sortAsc,
      quickFilter: quickFilter ?? this.quickFilter,
    );
  }
}

class ParityColumnSpec<T> {
  final String key;
  final String title;
  final double? width;
  final Alignment align;
  final bool sortable;

  const ParityColumnSpec({
    required this.key,
    required this.title,
    this.width,
    this.align = Alignment.centerLeft,
    this.sortable = false,
  });
}

class _ParityDataTableState<T> extends State<ParityDataTable<T>> {
  late ParityServerQuery _q;
  late List<double?> _widths; // per column
  List<T> _rows = <T>[];
  int _total = 0;
  bool _loading = false;
  Object? _lastError;
  final TextEditingController _filterCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _q = ParityServerQuery(page: 1, pageSize: widget.initialPageSize, sortBy: widget.sortBy, sortAsc: widget.sortAsc);
    _widths = widget.columns.map<double?>((c) => c.width).toList(growable: false);
    _load();
    _filterCtrl.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _filterCtrl.removeListener(_onFilterChanged);
    _filterCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onFilterChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() { _q = _q.copyWith(page: 1, quickFilter: _filterCtrl.text.trim().isEmpty ? null : _filterCtrl.text.trim()); });
      _load();
    });
  }

  Future<void> _load() async {
    setState(() { _loading = true; _lastError = null; });
    try {
      final page = await widget.fetch(_q);
      setState(() { _rows = page.rows; _total = page.total; _loading = false; });
    } catch (e) {
      setState(() { _lastError = e; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rowH = switch (widget.density) {
      ParityTableDensity.compact => 40.0,
      ParityTableDensity.standard => 44.0,
      ParityTableDensity.comfortable => 52.0,
    };
    final headerH = switch (widget.density) {
      ParityTableDensity.compact => 40.0,
      ParityTableDensity.standard => 48.0,
      ParityTableDensity.comfortable => 56.0,
    };
    const minColWidth = 80.0;
    const fallbackColWidth = 160.0;

    final resolvedWidths = List<double>.generate(widget.columns.length, (i) => _widths[i] ?? widget.columns[i].width ?? fallbackColWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Toolbar row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 260,
                child: TextField(
                  controller: _filterCtrl,
                  decoration: InputDecoration(
                    hintText: widget.quickFilterPlaceholder,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                  ),
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
                items: widget.availablePageSizes.map((s) => DropdownMenuItem(value: s, child: Text('Page: $s'))).toList(),
              ),
              const Spacer(),
              if (widget.toolbar != null) widget.toolbar!,
            ],
          ),
        ),
        // Sticky header + divider
        SemanticsRoles.tableHeader(
          child: Column(
            children: [
              SizedBox(
                height: headerH,
                child: Row(children: List.generate(widget.columns.length, (i) {
                  final spec = widget.columns[i];
                  final asc = _q.sortAsc;
                  final isSorted = _q.sortBy == spec.key;
                  return _HeaderCell(
                    width: resolvedWidths[i],
                    title: spec.title,
                    sortable: spec.sortable,
                    sortIcon: isSorted ? (asc ? Icons.arrow_upward : Icons.arrow_downward) : Icons.unfold_more,
                    onSort: spec.sortable ? () {
                      final ascNext = isSorted ? !asc : true;
                      setState(() => _q = _q.copyWith(sortBy: spec.key, sortAsc: ascNext, page: 1));
                      _load();
                    } : null,
                    onResize: (delta) {
                      setState(() {
                        final base = resolvedWidths[i];
                        final next = (base + delta).clamp(minColWidth, 800.0);
                        _widths[i] = next;
                      });
                    },
                  );
                })),
              ),
              SizedBox(height: 8, child: Container(color: theme.dividerColor.withValues(alpha: 0.50))),
            ],
          ),
        ),
        // Body
        Expanded(
          child: _loading
              ? const LoadingState()
              : _lastError != null
                  ? (widget.errorBuilder?.call(context, _lastError!, _load) ?? ErrorState(message: '$_lastError', onRetry: _load))
                  : _rows.isEmpty
                      ? (widget.emptyBuilder?.call(context) ?? const EmptyState(subtitle: 'Try changing filters or page size.'))
                      : _buildBody(theme, rowH, resolvedWidths),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: _buildFooter(theme),
        )
      ],
    );
  }

  Widget _buildBody(ThemeData theme, double rowH, List<double> widths) {
    return Scrollbar(
      child: ListView.builder(
        cacheExtent: widget.cacheExtent,
        itemCount: _rows.length * 2 - 1, // row + divider between rows
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.50));
          }
          final rowIndex = i ~/ 2;
          final row = _rows[rowIndex];
          final child = SizedBox(height: rowH, child: widget.rowBuilder(context, row, widths));
          return SemanticsRoles.dataRow(index: rowIndex, total: _rows.length, child: child);
        },
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final pages = (_total / _q.pageSize).ceil().clamp(1, 999999);
    final start = (_rows.isEmpty ? 0 : ((_q.page - 1) * _q.pageSize + 1)).clamp(0, _total);
    final end = (_rows.isEmpty ? 0 : ((_q.page - 1) * _q.pageSize + _rows.length)).clamp(0, _total);
    return Row(children: [
      Text('Showing $start–$end of $_total'),
      const Spacer(),
      IconButton(onPressed: _q.page > 1 ? () { setState(() { _q = _q.copyWith(page: 1); }); _load(); } : null, icon: const Icon(Icons.first_page)),
      IconButton(onPressed: _q.page > 1 ? () { setState(() { _q = _q.copyWith(page: _q.page - 1); }); _load(); } : null, icon: const Icon(Icons.chevron_left)),
      Text('Page ${_q.page} / $pages'),
      IconButton(onPressed: _q.page < pages ? () { setState(() { _q = _q.copyWith(page: _q.page + 1); }); _load(); } : null, icon: const Icon(Icons.chevron_right)),
      IconButton(onPressed: _q.page < pages ? () { setState(() { _q = _q.copyWith(page: pages); }); _load(); } : null, icon: const Icon(Icons.last_page)),
    ]);
  }
}

class _HeaderCell extends StatefulWidget {
  const _HeaderCell({
    required this.width,
    required this.title,
    required this.sortable,
    this.sortIcon,
    this.onSort,
    required this.onResize,
  });

  final double width;
  final String title;
  final bool sortable;
  final IconData? sortIcon;
  final VoidCallback? onSort;
  final void Function(double delta) onResize;

  @override
  State<_HeaderCell> createState() => _HeaderCellState();
}

class _HeaderCellState extends State<_HeaderCell> {
  double? _dragStartX;

  @override
  Widget build(BuildContext context) {
    final header = Container(
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
                if (widget.sortable) ...[
                  const SizedBox(width: 4),
                  Icon(widget.sortIcon ?? Icons.unfold_more, size: 16),
                ],
              ],
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (d) => _dragStartX = d.globalPosition.dx,
              onHorizontalDragUpdate: (d) {
                if (_dragStartX == null) return;
                final delta = d.globalPosition.dx - _dragStartX!;
                _dragStartX = d.globalPosition.dx;
                widget.onResize(delta);
              },
              onHorizontalDragEnd: (_) => _dragStartX = null,
              child: const SizedBox(width: 8, height: 36),
            ),
          ),
        ],
      ),
    );

    return widget.sortable && widget.onSort != null
        ? InkWell(onTap: widget.onSort, child: header)
        : header;
  }
}
