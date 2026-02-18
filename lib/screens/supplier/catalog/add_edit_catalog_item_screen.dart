import 'package:flutter/material.dart';

class AddEditCatalogItemScreen extends StatefulWidget {
  final String? itemId; // null for new
  const AddEditCatalogItemScreen({super.key, this.itemId});

  @override
  State<AddEditCatalogItemScreen> createState() => _AddEditCatalogItemScreenState();
}

class _AddEditCatalogItemScreenState extends State<AddEditCatalogItemScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void dispose() { _nameCtrl.dispose(); _priceCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final isEdit = widget.itemId != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit? 'Edit item' : 'Add item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Item name', prefixIcon: Icon(Icons.inventory_2))),
          const SizedBox(height: 12),
          TextField(controller: _priceCtrl, decoration: const InputDecoration(labelText: 'Unit price', prefixIcon: Icon(Icons.attach_money)), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)), maxLines: 3),
          const SizedBox(height: 16),
          SizedBox(height: 48, child: FilledButton(onPressed: (){ Navigator.of(context).pop(); }, child: Text(isEdit? 'Save changes' : 'Add item', style: ts.labelLarge?.copyWith(color: cs.onPrimary)))),
        ]),
      ),
    );
  }
}
