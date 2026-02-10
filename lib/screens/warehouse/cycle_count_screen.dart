import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';

class WarehouseCycleCountScreen extends StatefulWidget {
  const WarehouseCycleCountScreen({super.key});

  @override
  State<WarehouseCycleCountScreen> createState() => _WarehouseCycleCountScreenState();
}

class _WarehouseCycleCountScreenState extends State<WarehouseCycleCountScreen> {
  String? _whId;
  String? _itemId;
  final _newQtyCtrl = TextEditingController();

  @override
  void dispose() {
    _newQtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MockDataService>();
    final whs = data.warehouses;
    final items = data.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Count')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _whId,
              items: whs.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
              onChanged: (v) => setState(() => _whId = v),
              decoration: const InputDecoration(labelText: 'Warehouse', prefixIcon: Icon(Icons.warehouse)),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _itemId,
              items: items.map((it) => DropdownMenuItem(value: it.id, child: Text('${it.name} • ${it.code}'))).toList(),
              onChanged: (v) => setState(() => _itemId = v),
              decoration: const InputDecoration(labelText: 'Item', prefixIcon: Icon(Icons.inventory_2_outlined)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newQtyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'New quantity', prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final qty = double.tryParse(_newQtyCtrl.text.trim());
                  if (_whId == null || _itemId == null || qty == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields.')));
                    return;
                  }
                  final ok = context.read<MockDataService>().adjustStock(warehouseId: _whId!, itemId: _itemId!, newQuantity: qty);
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock adjusted.')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adjustment failed.')));
                  }
                },
                icon: const Icon(Icons.save_as_outlined),
                label: const Text('Save Count'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
