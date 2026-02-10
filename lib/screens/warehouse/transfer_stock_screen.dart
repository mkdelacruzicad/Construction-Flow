import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';

class WarehouseTransferScreen extends StatefulWidget {
  const WarehouseTransferScreen({super.key});

  @override
  State<WarehouseTransferScreen> createState() => _WarehouseTransferScreenState();
}

class _WarehouseTransferScreenState extends State<WarehouseTransferScreen> {
  String? _fromWh;
  String? _toWh;
  String? _itemId;
  final _qtyCtrl = TextEditingController();

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MockDataService>();
    final warehouses = data.warehouses;
    final items = data.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Transfer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: _WarehouseDropdown(value: _fromWh, warehouses: warehouses, label: 'From', onChanged: (v) => setState(() => _fromWh = v))),
              const SizedBox(width: 12),
              Expanded(child: _WarehouseDropdown(value: _toWh, warehouses: warehouses, label: 'To', onChanged: (v) => setState(() => _toWh = v))),
            ]),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _itemId,
              items: items.map((it) => DropdownMenuItem(value: it.id, child: Text('${it.name} • ${it.code}'))).toList(),
              decoration: const InputDecoration(labelText: 'Item', prefixIcon: Icon(Icons.inventory_2_outlined)),
              onChanged: (v) => setState(() => _itemId = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity', prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final qty = double.tryParse(_qtyCtrl.text.trim());
                  if (_fromWh == null || _toWh == null || _itemId == null || qty == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields.')));
                    return;
                  }
                  if (_fromWh == _toWh) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('From and To cannot be the same.')));
                    return;
                  }
                  final ok = context.read<MockDataService>().transferStock(itemId: _itemId!, fromWarehouseId: _fromWh!, toWarehouseId: _toWh!, quantity: qty);
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transfer completed.')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transfer failed. Check stock levels.')));
                  }
                },
                icon: const Icon(Icons.compare_arrows_rounded),
                label: const Text('Transfer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarehouseDropdown extends StatelessWidget {
  final String? value;
  final List<Warehouse> warehouses;
  final String label;
  final ValueChanged<String?> onChanged;
  const _WarehouseDropdown({required this.value, required this.warehouses, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: warehouses.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.warehouse_outlined)),
    );
  }
}
