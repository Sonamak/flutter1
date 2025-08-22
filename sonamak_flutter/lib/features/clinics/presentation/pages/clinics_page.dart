
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/clinics/controllers/clinics_controller.dart';
import 'package:sonamak_flutter/features/clinics/data/clinics_repository.dart';
import 'package:sonamak_flutter/features/clinics/data/clinics_models.dart';

class ClinicsPage extends StatefulWidget {
  const ClinicsPage({super.key});

  @override
  State<ClinicsPage> createState() => _ClinicsPageState();
}

class _ClinicsPageState extends State<ClinicsPage> {
  late final ClinicsController controller;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = ClinicsController(ClinicsRepository())..load();
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
        appBar: AppBar(
          title: const Text('Clinics management'),
          actions: [
            IconButton(onPressed: () => showDialog(context: context, builder: (_) => _AddClinicDialog(onSave: (payload) async {
              final ok = await controller.addClinic(payload);
              if (!mounted) return;
              ok ? AppSnackbar.showSuccess(context, 'Clinic saved') : AppSnackbar.showError(context, 'Failed');
            })), icon: const Icon(Icons.add_business_outlined)),
          ],
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            final items = _filtered(st.clinics);
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
                              final c = items[i];
                              return ListTile(
                                selected: st.selected?.id == c.id,
                                title: Text(c.name),
                                subtitle: Text([c.email, c.phone, c.subdomain].where((e) => (e ?? '').isNotEmpty).join(' • ')),
                                trailing: Chip(
                                  label: Text(c.active ? 'Active' : 'Suspended'),
                                  backgroundColor: c.active ? Colors.green.shade100 : Colors.orange.shade100,
                                ),
                                onTap: () => controller.select(c),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: st.selected == null ? const Center(child: Text('Select a clinic')) : _ClinicDetail(
                      clinic: st.selected!,
                      onSuspend: () async {
                        final ok = await controller.toggleSuspend();
                        if (!mounted) return;
                        ok ? AppSnackbar.showSuccess(context, 'Updated') : AppSnackbar.showError(context, 'Failed');
                      },
                      onAddExtras: (extras) async {
                        final ok = await controller.addExtras(st.selected!.id, extras);
                        if (!mounted) return;
                        ok ? AppSnackbar.showSuccess(context, 'Extras added') : AppSnackbar.showError(context, 'Failed');
                      },
                      onUpdateSubscription: (s) async {
                        final ok = await controller.updateSubscription(s);
                        if (!mounted) return;
                        ok ? AppSnackbar.showSuccess(context, 'Subscription saved') : AppSnackbar.showError(context, 'Failed');
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

  List<Clinic> _filtered(List<Clinic> list) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((c) =>
      c.name.toLowerCase().contains(q) ||
      (c.email ?? '').toLowerCase().contains(q) ||
      (c.phone ?? '').contains(q) ||
      (c.subdomain ?? '').toLowerCase().contains(q)
    ).toList(growable: false);
  }
}

class _ClinicDetail extends StatelessWidget {
  const _ClinicDetail({required this.clinic, required this.onSuspend, required this.onAddExtras, required this.onUpdateSubscription});
  final Clinic clinic;
  final Future<void> Function() onSuspend;
  final Future<void> Function(List<Map<String, dynamic>> extras) onAddExtras;
  final Future<void> Function(Subscription s) onUpdateSubscription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(clinic.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 8),
            Chip(label: Text((clinic.status == '1') ? 'Success' : 'Declined')),
            const Spacer(),
            OutlinedButton.icon(onPressed: onSuspend, icon: const Icon(Icons.pause_circle_outline), label: Text(clinic.active ? 'Suspend' : 'Unsuspend')),
            const SizedBox(width: 8),
            ElevatedButton.icon(onPressed: () async {
              final resp = await showDialog<List<Map<String, dynamic>>>(context: context, builder: (_) => _AddExtrasDialog());
              if (resp != null && resp.isNotEmpty) await onAddExtras(resp);
            }, icon: const Icon(Icons.add_shopping_cart_outlined), label: const Text('Add extra')),
          ]),
          const SizedBox(height: 8),
          Text([clinic.email, clinic.phone, clinic.subdomain].where((e) => (e ?? '').isNotEmpty).join(' • ')),
          const SizedBox(height: 12),
          Text('Subscriptions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            child: clinic.subscriptions.isEmpty ? const Center(child: Text('No subscriptions')) : ListView.separated(
              itemCount: clinic.subscriptions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final s = clinic.subscriptions[i];
                return ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(s.name),
                  subtitle: Text([s.createdAt, s.duration == null ? null : '${s.duration} mo'].where((e) => (e ?? '').isNotEmpty).join(' • ')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text((s.status == '1') ? 'Success' : 'Declined'),
                      const SizedBox(width: 8),
                      IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () async {
                        final edited = await showDialog<Subscription>(context: context, builder: (_) => _EditSubscriptionDialog(sub: s));
                        if (edited != null) await onUpdateSubscription(edited);
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddClinicDialog extends StatefulWidget {
  const _AddClinicDialog({required this.onSave});
  final Future<void> Function(Map<String, dynamic>) onSave;

  @override
  State<_AddClinicDialog> createState() => _AddClinicDialogState();
}

class _AddClinicDialogState extends State<_AddClinicDialog> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _countryCode = TextEditingController();
  final _subdomain = TextEditingController();
  final _password = TextEditingController();
  final _currencyId = TextEditingController();
  String? _planValue;

  @override
  void dispose() {
    _name.dispose(); _email.dispose(); _phone.dispose(); _countryCode.dispose(); _subdomain.dispose(); _password.dispose(); _currencyId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add clinic'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            children: [
              TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
              Row(children: [
                SizedBox(width: 120, child: TextField(controller: _countryCode, decoration: const InputDecoration(labelText: 'Country code'))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone'))),
              ]),
              TextField(controller: _subdomain, decoration: const InputDecoration(labelText: 'Subdomain')),
              TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              TextField(controller: _currencyId, decoration: const InputDecoration(labelText: 'Currency ID')),
              DropdownButtonFormField<String>(
                value: _planValue,
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Plan 1')),
                  DropdownMenuItem(value: '2', child: Text('Plan 2')),
                  DropdownMenuItem(value: '3', child: Text('Plan 3')),
                ],
                onChanged: (v) => setState(() => _planValue = v),
                decoration: const InputDecoration(labelText: 'Plan'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () async {
          final payload = {
            'name': _name.text.trim(),
            'email': _email.text.trim(),
            'phone': _phone.text.trim().isEmpty ? null : _phone.text.trim(),
            'countryCode': _countryCode.text.trim(),
            'subdomain': _subdomain.text.trim(),
            'password': _password.text.trim(),
            'currency_id': int.tryParse(_currencyId.text.trim()),
            'plan': _planValue,
          }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
          await widget.onSave(payload);
          if (context.mounted) Navigator.pop(context);
        }, child: const Text('Save')),
      ],
    );
  }
}

class _AddExtrasDialog extends StatefulWidget {
  @override
  State<_AddExtrasDialog> createState() => _AddExtrasDialogState();
}

class _AddExtrasDialogState extends State<_AddExtrasDialog> {
  final List<Map<String, dynamic>> rows = List.generate(8, (i) => {'id': i + 1, 'is_active': false, 'count': 0, 'is_free': false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add extra package'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < rows.length; i++) Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Expanded(child: Text('Extra #${rows[i]['id']}')),
                Checkbox(value: rows[i]['is_active'] as bool, onChanged: (v) => setState(() => rows[i]['is_active'] = v ?? false)),
                const SizedBox(width: 8),
                SizedBox(width: 80, child: TextField(
                  decoration: const InputDecoration(labelText: 'Count'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => rows[i]['count'] = int.tryParse(v) ?? 0,
                )),
                const SizedBox(width: 8),
                Checkbox(value: (rows[i]['is_free'] as bool?) ?? false, onChanged: (v) => setState(() => rows[i]['is_free'] = v ?? false)),
              ]),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          final payload = rows.where((e) => e['is_active'] == true).toList(growable: false);
          Navigator.pop(context, payload);
        }, child: const Text('Add')),
      ],
    );
  }
}

class _EditSubscriptionDialog extends StatefulWidget {
  const _EditSubscriptionDialog({required this.sub});
  final Subscription sub;

  @override
  State<_EditSubscriptionDialog> createState() => _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<_EditSubscriptionDialog> {
  late final TextEditingController name;
  late final TextEditingController createdAt;
  late final TextEditingController price;
  late final TextEditingController duration;
  String? statusValue;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.sub.name);
    createdAt = TextEditingController(text: widget.sub.createdAt ?? '');
    price = TextEditingController(text: widget.sub.price?.toString() ?? '');
    duration = TextEditingController(text: widget.sub.duration?.toString() ?? '');
    statusValue = widget.sub.status ?? '1';
  }

  @override
  void dispose() {
    name.dispose(); createdAt.dispose(); price.dispose(); duration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit subscription'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: createdAt, decoration: const InputDecoration(labelText: 'Created at (YYYY-MM-DD)')),
            TextField(controller: price, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: duration, decoration: const InputDecoration(labelText: 'Duration (months)'), keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: statusValue,
              items: const [
                DropdownMenuItem(value: '1', child: Text('Success')),
                DropdownMenuItem(value: '0', child: Text('Declined')),
              ],
              onChanged: (v) => setState(() => statusValue = v),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          final s = Subscription(
            id: widget.sub.id,
            name: name.text.trim(),
            createdAt: createdAt.text.trim(),
            price: num.tryParse(price.text.trim()),
            duration: int.tryParse(duration.text.trim()),
            status: statusValue,
          );
          Navigator.pop(context, s);
        }, child: const Text('Save')),
      ],
    );
  }
}
