import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';

class WarehouseDispatchScreen extends StatefulWidget {
  const WarehouseDispatchScreen({super.key});

  @override
  State<WarehouseDispatchScreen> createState() => _WarehouseDispatchScreenState();
}

class _WarehouseDispatchScreenState extends State<WarehouseDispatchScreen> {
  String? _whId;
  String? _itemId;
  final _qtyCtrl = TextEditingController();
  final _projectCtrl = TextEditingController();

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _projectCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MockDataService>();
    final whs = data.warehouses;
    final items = data.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Dispatch / Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _whId,
              items: whs.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
              onChanged: (v) => setState(() => _whId = v),
              decoration: const InputDecoration(labelText: 'Warehouse', prefixIcon: Icon(Icons.warehouse_outlined)),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _itemId,
              items: items.map((it) => DropdownMenuItem(value: it.id, child: Text('${it.name} • ${it.code}'))).toList(),
              onChanged: (v) => setState(() => _itemId = v),
              decoration: const InputDecoration(labelText: 'Item', prefixIcon: Icon(Icons.inventory_outlined)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity to dispatch', prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _projectCtrl,
              decoration: const InputDecoration(labelText: 'Project / Site (optional)', prefixIcon: Icon(Icons.location_on_outlined)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final qty = double.tryParse(_qtyCtrl.text.trim());
                  if (_whId == null || _itemId == null || qty == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete required fields.')));
                    return;
                  }
                  final ok = context.read<MockDataService>().dispatchStock(warehouseId: _whId!, itemId: _itemId!, quantity: qty);
                  if (ok) {
                    final proj = _projectCtrl.text.trim();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dispatched $qty from ${whs.firstWhere((w) => w.id == _whId).name}${proj.isNotEmpty ? ' to $proj' : ''}.')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dispatch failed. Check stock.')));
                  }
                },
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text('Dispatch'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
