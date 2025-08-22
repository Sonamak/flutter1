
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/hr/controllers/users_controller.dart';
import 'package:sonamak_flutter/features/hr/data/hr_repository.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final UsersController controller;

  @override
  void initState() {
    super.initState();
    controller = UsersController(HrRepository())..load();
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          actions: [
            IconButton(onPressed: () async {
              final ok = await controller.exportExcel();
              if (!mounted) return;
              ok ? AppSnackbar.showSuccess(context, 'Export requested') : AppSnackbar.showError(context, 'Export failed');
            }, icon: const Icon(Icons.download_outlined)),
          ],
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            return Row(
              children: [
                SizedBox(
                  width: 320,
                  child: st.loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          itemCount: st.users.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final u = st.users[i];
                            return ListTile(
                              leading: CircleAvatar(child: Text(u.name.isNotEmpty ? u.name[0].toUpperCase() : '?')),
                              title: Text(u.name),
                              subtitle: Text([u.role, u.email, u.phone].where((e) => e != null && e.isNotEmpty).map((e) => e!).join(' • ')),
                              onTap: () => controller.openDetail(u.id),
                              trailing: PopupMenuButton<String>(
                                onSelected: (v) async {
                                  if (v == 'delete') {
                                    final ok = await controller.remove(u.id);
                                    if (!mounted) return;
                                    ok ? AppSnackbar.showSuccess(context, 'Deleted') : AppSnackbar.showError(context, 'Delete failed');
                                  } else if (v == 'reset') {
                                    final ok = await controller.resetPassword({'id': u.id});
                                    if (!mounted) return;
                                    ok ? AppSnackbar.showSuccess(context, 'Password reset') : AppSnackbar.showError(context, 'Reset failed');
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: 'reset', child: Text('Reset password')),
                                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: st.detail == null
                        ? const Center(child: Text('Select a user to view details'))
                        : _UserDetail(data: st.detail!, onSave: (payload) async {
                            final ok = await controller.update(payload);
                            if (!mounted) return;
                            ok ? AppSnackbar.showSuccess(context, 'Saved') : AppSnackbar.showError(context, 'Save failed');
                          }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UserDetail extends StatefulWidget {
  const _UserDetail({required this.data, required this.onSave});
  final Map<String, dynamic> data;
  final Future<void> Function(Map<String, dynamic>) onSave;

  @override
  State<_UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<_UserDetail> {
  late final TextEditingController name;
  late final TextEditingController phone;
  late final TextEditingController email;
  late final TextEditingController role;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: '${widget.data['name'] ?? ''}');
    phone = TextEditingController(text: '${widget.data['phone'] ?? ''}');
    email = TextEditingController(text: '${widget.data['email'] ?? ''}');
    role = TextEditingController(text: '${widget.data['role'] ?? widget.data['role_name'] ?? ''}');
  }

  @override
  void dispose() {
    name.dispose(); phone.dispose(); email.dispose(); role.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: TextField(controller: name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: email, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: role, decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()))),
        ]),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(onPressed: () {
            final payload = {
              'id': widget.data['id'],
              'name': name.text.trim(),
              'email': email.text.trim(),
              'phone': phone.text.trim(),
              'role': role.text.trim().isEmpty ? null : role.text.trim(),
            }..removeWhere((k,v) => v == null);
            widget.onSave(payload);
          }, icon: const Icon(Icons.save_outlined), label: const Text('Save')),
        ),
      ],
    );
  }
}
