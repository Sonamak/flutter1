
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/hr/controllers/permissions_controller.dart';
import 'package:sonamak_flutter/features/hr/data/hr_models.dart';
import 'package:sonamak_flutter/features/hr/data/hr_repository.dart';

class UsersPermissionsPage extends StatefulWidget {
  const UsersPermissionsPage({super.key});

  @override
  State<UsersPermissionsPage> createState() => _UsersPermissionsPageState();
}

class _UsersPermissionsPageState extends State<UsersPermissionsPage> {
  late final PermissionsController controller;
  final _roleCtrl = TextEditingController(text: '0');
  final _newRoleName = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = PermissionsController(HrRepository())..load(int.tryParse(_roleCtrl.text.trim()) ?? 0);
  }

  @override
  void dispose() {
    _roleCtrl.dispose();
    _newRoleName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users permissions'),
          actions: [
            IconButton(onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Create role'),
                  content: TextField(controller: _newRoleName, decoration: const InputDecoration(labelText: 'Role name', border: OutlineInputBorder())),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create')),
                  ],
                ),
              ) ?? false;
              if (!ok) return;
              final ok2 = await controller.roleCreate(_newRoleName.text.trim());
              if (!mounted) return;
              ok2 ? AppSnackbar.showSuccess(context, 'Role created') : AppSnackbar.showError(context, 'Failed');
            }, icon: const Icon(Icons.add_moderator_outlined)),
          ],
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(children: [
                    SizedBox(width: 140, child: TextField(controller: _roleCtrl, decoration: const InputDecoration(labelText: 'Role ID', border: OutlineInputBorder()))),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () => controller.load(int.tryParse(_roleCtrl.text.trim()) ?? 0), child: const Text('Load')),
                    const Spacer(),
                    ElevatedButton.icon(onPressed: () async {
                      final ok = await controller.roleUpdate(st.role, st.tree);
                      if (!mounted) return;
                      ok ? AppSnackbar.showSuccess(context, 'Saved') : AppSnackbar.showError(context, 'Save failed');
                    }, icon: const Icon(Icons.save_outlined), label: const Text('Save')),
                  ]),
                  const SizedBox(height: 12),
                  Expanded(
                    child: st.loading ? const Center(child: CircularProgressIndicator()) : _PermissionTree(tree: st.tree, onToggle: (path) {
                      // mutate allowed flags locally
                      void walk(List<PermissionNode> list) {
                        for (var i = 0; i < list.length; i++) {
                          final n = list[i];
                          if (n.key == path) {
                            list[i] = n.copyWith(allowed: !n.allowed);
                            return;
                          }
                          walk(list[i].children);
                        }
                      }
                      walk(st.tree);
                      setState((){});
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
}

class _PermissionTree extends StatelessWidget {
  const _PermissionTree({required this.tree, required this.onToggle});
  final List<PermissionNode> tree;
  final void Function(String path) onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: tree.map((n) => _Node(node: n, onToggle: onToggle)).toList(growable: false),
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({required this.node, required this.onToggle});
  final PermissionNode node;
  final void Function(String path) onToggle;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Switch(value: node.allowed, onChanged: (_) => onToggle(node.key)),
          const SizedBox(width: 8),
          Text(node.label),
        ],
      ),
      children: node.children.map((c) => Padding(
        padding: const EdgeInsets.only(left: 16),
        child: _Node(node: c, onToggle: onToggle),
      )).toList(growable: false),
    );
  }
}
