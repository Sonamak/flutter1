
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/branches/controllers/branches_controller.dart';
import 'package:sonamak_flutter/features/branches/data/branch_models.dart';
import 'package:sonamak_flutter/features/branches/data/branches_repository.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  late final BranchesController controller;
  final _search = TextEditingController();
  Branch? _selected;

  @override
  void initState() {
    super.initState();
    controller = BranchesController(BranchesRepository())..load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Branches')),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            final items = _filtered(st.branches);
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(
                    width: 360,
                    child: Column(
                      children: [
                        TextField(controller: _search, decoration: const InputDecoration(labelText: 'Search', border: OutlineInputBorder())),
                        const SizedBox(height: 8),
                        Expanded(
                          child: st.loading ? const Center(child: CircularProgressIndicator()) : ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, i) {
                              final b = items[i];
                              return ListTile(
                                selected: _selected?.id == b.id,
                                title: Text(b.name),
                                subtitle: Text([b.phone, b.location].where((e) => (e ?? '').isNotEmpty).join(' • ')),
                                onTap: () => setState(() => _selected = b),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    final ok = await controller.delete(b.id);
                                    if (!mounted) return;
                                    ok ? AppSnackbar.showSuccess(context, 'Deleted') : AppSnackbar.showError(context, 'Failed');
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: _selected == null ? const Center(child: Text('Select a branch')) : _BranchEditor(branch: _selected!, onSave: (payload) async {
                      final ok = await controller.update(payload);
                      if (!mounted) return;
                      ok ? AppSnackbar.showSuccess(context, 'Saved') : AppSnackbar.showError(context, 'Failed');
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Branch> _filtered(List<Branch> list) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((b) => (b.name.toLowerCase().contains(q) || (b.phone ?? '').contains(q) || (b.location ?? '').toLowerCase().contains(q))).toList(growable: false);
  }
}

class _BranchEditor extends StatefulWidget {
  const _BranchEditor({required this.branch, required this.onSave});
  final Branch branch;
  final Future<void> Function(Branch) onSave;

  @override
  State<_BranchEditor> createState() => _BranchEditorState();
}

class _BranchEditorState extends State<_BranchEditor> {
  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController countryCode;
  late TextEditingController locationCtrl;
  late TextEditingController mapCtrl;
  late TextEditingController fromCtrl;
  late TextEditingController toCtrl;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.branch.name);
    phone = TextEditingController(text: widget.branch.phone ?? '');
    countryCode = TextEditingController(text: widget.branch.countryCode ?? '');
    locationCtrl = TextEditingController(text: widget.branch.location ?? '');
    mapCtrl = TextEditingController(text: widget.branch.map ?? '');
    fromCtrl = TextEditingController(text: widget.branch.from ?? '');
    toCtrl = TextEditingController(text: widget.branch.to ?? '');
  }

  @override
  void dispose() {
    name.dispose(); phone.dispose(); countryCode.dispose(); locationCtrl.dispose(); mapCtrl.dispose(); fromCtrl.dispose(); toCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit branch', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            SizedBox(width: 140, child: TextField(controller: countryCode, decoration: const InputDecoration(labelText: 'Country code', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 8),
          TextField(controller: mapCtrl, decoration: const InputDecoration(labelText: 'Map URL', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: fromCtrl, decoration: const InputDecoration(labelText: 'Open from (HH:mm)', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: toCtrl, decoration: const InputDecoration(labelText: 'Open to (HH:mm)', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(onPressed: () {
              final b = Branch(
                id: widget.branch.id,
                name: name.text.trim(),
                phone: phone.text.trim(),
                countryCode: countryCode.text.trim(),
                location: locationCtrl.text.trim(),
                map: mapCtrl.text.trim(),
                from: fromCtrl.text.trim(),
                to: toCtrl.text.trim(),
              );
              widget.onSave(b);
            }, icon: const Icon(Icons.save_outlined), label: const Text('Save')),
          ),
        ],
      ),
    );
  }
}
