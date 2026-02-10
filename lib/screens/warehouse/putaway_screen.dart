import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';

class WarehousePutawayScreen extends StatelessWidget {
  const WarehousePutawayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MockDataService>();
    final inv = data.inventory;
    final items = data.items;
    final whs = data.warehouses;

    return Scaffold(
      appBar: AppBar(title: const Text('Putaway')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: inv.isEmpty
            ? const Center(child: Text('No items pending putaway.'))
            : ListView.separated(
                itemCount: inv.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  final row = inv[i];
                  final item = items.firstWhere((it) => it.id == row.itemId);
                  final wh = whs.firstWhere((w) => w.id == row.warehouseId);
                  final binCtrl = TextEditingController();
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(backgroundImage: NetworkImage(item.imageUrl)),
                            title: Text(item.name),
                            subtitle: Text('${row.quantityOnHand} ${item.unit} • ${wh.name}'),
                          ),
                          TextField(
                            controller: binCtrl,
                            decoration: const InputDecoration(labelText: 'Assign bin/location (mock)', prefixIcon: Icon(Icons.grid_view_outlined)),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved bin ${binCtrl.text.trim().isEmpty ? '—' : binCtrl.text.trim()} for ${item.name} (mock).')));
                              },
                              icon: const Icon(Icons.save_outlined),
                              label: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
