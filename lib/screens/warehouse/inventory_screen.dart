import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';

class WarehouseInventoryScreen extends StatefulWidget {
  const WarehouseInventoryScreen({super.key});

  @override
  State<WarehouseInventoryScreen> createState() => _WarehouseInventoryScreenState();
}

class _WarehouseInventoryScreenState extends State<WarehouseInventoryScreen> {
  String? _warehouseId;
  String _query = '';
  bool _lowStockOnly = false;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MockDataService>();
    final warehouses = data.warehouses;
    final items = data.items;

    final all = data.inventory.where((inv) => _warehouseId == null || inv.warehouseId == _warehouseId).toList();
    final filtered = all.where((inv) {
      final item = items.firstWhere((i) => i.id == inv.itemId);
      final matches = _query.isEmpty || item.name.toLowerCase().contains(_query.toLowerCase()) || item.code.toLowerCase().contains(_query.toLowerCase());
      final low = !_lowStockOnly || inv.quantityOnHand <= inv.minStockLevel;
      return matches && low;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String?> (
                  value: _warehouseId,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Warehouses')),
                    ...warehouses.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))),
                  ],
                  onChanged: (v) => setState(() => _warehouseId = v),
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.warehouse_outlined), labelText: 'Warehouse'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search item or code'),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              FilterChip(
                label: const Text('Low stock only'),
                selected: _lowStockOnly,
                onSelected: (v) => setState(() => _lowStockOnly = v),
                selectedColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                checkmarkColor: Theme.of(context).colorScheme.secondary,
              ),
              const Spacer(),
              Text('${filtered.length} items', style: context.textStyles.labelMedium),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No inventory matches your filters.'))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final inv = filtered[i];
                        final item = items.firstWhere((it) => it.id == inv.itemId);
                        final wh = warehouses.firstWhere((w) => w.id == inv.warehouseId);
                        final isLow = inv.quantityOnHand <= inv.minStockLevel;
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(backgroundImage: NetworkImage(item.imageUrl)),
                            title: Text('${item.name} • ${item.code}'),
                            subtitle: Text(wh.name),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${NumberFormat('#,##0.##').format(inv.quantityOnHand)} ${item.unit}',
                                  style: context.textStyles.titleMedium?.bold.copyWith(color: isLow ? Colors.red : Theme.of(context).colorScheme.onSurface),
                                ),
                                if (isLow) Text('Low', style: context.textStyles.labelSmall?.withColor(Colors.red)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
