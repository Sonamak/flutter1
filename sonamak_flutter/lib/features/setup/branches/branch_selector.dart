import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/utils/branch_persistence.dart';

class Branch {
  final String id;
  final String name;
  const Branch({required this.id, required this.name});
}

abstract class BranchDataSource {
  Future<List<Branch>> listBranches();
}

class BranchSelector extends StatefulWidget {
  const BranchSelector({super.key, required this.dataSource, this.onChanged});
  final BranchDataSource dataSource;
  final ValueChanged<Branch?>? onChanged;

  @override
  State<BranchSelector> createState() => _BranchSelectorState();
}

class _BranchSelectorState extends State<BranchSelector> {
  bool _loading = true;
  List<Branch> _branches = const <Branch>[];
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await widget.dataSource.listBranches();
      String? saved = await BranchPersistence.loadBranchId();

      // sanitize: saved must exist in items
      if (saved != null && !items.any((b) => b.id == saved)) saved = null;

      final initialId = saved ?? (items.isNotEmpty ? items.first.id : null);

      setState(() {
        _branches = items;
        _selectedId = initialId;
        _loading = false;
      });

      // notify initial selection (null if not found)
      widget.onChanged?.call(_byId(initialId, items));
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Branch? _byId(String? id, [List<Branch>? list]) {
    if (id == null) return null;
    final L = list ?? _branches;
    for (final b in L) {
      if (b.id == id) return b;
    }
    return null;
  }

  Future<void> _onChanged(String? id) async {
    if (!mounted) return;
    setState(() => _selectedId = id);
    if (id != null) await BranchPersistence.saveBranchId(id);
    widget.onChanged?.call(_byId(id));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 160, height: 40,
        child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    // Guarantee dropdown value is either null or in items
    final value = (_selectedId != null && _branches.any((b) => b.id == _selectedId)) ? _selectedId : null;

    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        value: value,
        items: _branches.map((b) => DropdownMenuItem<String>(value: b.id, child: Text(b.name, overflow: TextOverflow.ellipsis))).toList(growable: false),
        onChanged: _onChanged,
        decoration: const InputDecoration(
          labelText: 'Branch',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
