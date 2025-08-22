
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/store/controllers/store_controller.dart';
import 'package:sonamak_flutter/features/store/data/store_models.dart';
import 'package:sonamak_flutter/features/store/data/store_repository.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late final StoreController controller;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = StoreController(StoreRepository())..bootstrap();
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
          title: const Text('Store / Inventory'),
          actions: [
            IconButton(
              onPressed: () => _openAddDialog(),
              icon: const Icon(Icons.add_box_outlined),
              tooltip: 'Add product',
            )
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
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: const Text('Main store'),
                                selected: st.selectedSubStoreId == null,
                                onSelected: (_) => controller.selectSubStore(null),
                              ),
                              const SizedBox(width: 8),
                              ...st.subStores.map((s) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ChoiceChip(
                                  label: Text(s.name),
                                  selected: st.selectedSubStoreId == s.id,
                                  onSelected: (_) => controller.selectSubStore(s.id),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(width: 260, child: TextField(controller: _search, onSubmitted: (v) => controller.setSearch(v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search', border: OutlineInputBorder()))),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: () => controller.setSearch(_search.text), child: const Text('Apply'))
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: st.loading
                        ? const Center(child: CircularProgressIndicator())
                        : _ProductsList(items: st.products),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openAddDialog() async {
    final name = TextEditingController();
    final itemId = TextEditingController();
    final cost = TextEditingController();
    final quantity = TextEditingController();
    final critical = TextEditingController();
    final expire = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add product'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()), validator: (v) => (v==null||v.trim().isEmpty)?'Required':null),
                  const SizedBox(height: 8),
                  TextFormField(controller: itemId, decoration: const InputDecoration(labelText: 'Item ID', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextFormField(controller: cost, decoration: const InputDecoration(labelText: 'Cost', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextFormField(controller: quantity, decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextFormField(controller: critical, decoration: const InputDecoration(labelText: 'Critical quantity', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextFormField(controller: expire, decoration: const InputDecoration(labelText: 'Expire date (YYYY-MM-DD)', border: OutlineInputBorder())),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
          ],
        );
      },
    ) ?? false;

    if (!ok) return;
    if (!formKey.currentState!.validate()) return;

    final params = {
      'name': name.text.trim(),
      if (itemId.text.trim().isNotEmpty) 'item_id': int.tryParse(itemId.text.trim()) ?? itemId.text.trim(),
      if (cost.text.trim().isNotEmpty) 'cost': num.tryParse(cost.text.trim()) ?? cost.text.trim(),
      if (quantity.text.trim().isNotEmpty) 'quantity': num.tryParse(quantity.text.trim()) ?? quantity.text.trim(),
      if (critical.text.trim().isNotEmpty) 'critical_quantity': num.tryParse(critical.text.trim()) ?? critical.text.trim(),
      if (expire.text.trim().isNotEmpty) 'expire_date': expire.text.trim(),
      'carton': 1,
    };
    final ok2 = await controller.addOrEditProduct(params);
    if (!mounted) return;
    ok2 ? AppSnackbar.showSuccess(context, 'Saved') : AppSnackbar.showError(context, 'Save failed');
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({required this.items});
  final List<StoreProductLite> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const Center(child: Text('No products'));
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final p = items[i];
        return ListTile(
          leading: const Icon(Icons.inventory_2_outlined),
          title: Text(p.name),
          subtitle: Text('Qty: ${p.quantity}'
              '${p.criticalQuantity != null ? ' • Critical: ${p.criticalQuantity}' : ''}'
              '${p.expireDate != null ? ' • Exp: ${p.expireDate}' : ''}'),
        );
      },
    );
  }
}
