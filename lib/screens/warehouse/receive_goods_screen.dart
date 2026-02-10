import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';
import 'package:intl/intl.dart';

class ReceiveGoodsScreen extends StatelessWidget {
  const ReceiveGoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final pendingPOs = dataService.purchaseOrders.where((po) => po.status == POStatus.issued).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Receive Goods')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pendingPOs.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('No pending Purchase Orders to receive.'),
                  ))
                else
                  ...pendingPOs.map((po) {
                    final supplier = dataService.users.firstWhere((u) => u.id == po.supplierId);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        title: Text('PO #${po.id.substring(0, 8)}'),
                        subtitle: Text('${supplier.companyName} • \$${po.totalAmount.toStringAsFixed(2)}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Items to Receive:', style: context.textStyles.titleMedium?.bold),
                                const SizedBox(height: 8),
                                ...po.items.map((poItem) {
                                  final item = dataService.items.firstWhere((i) => i.id == poItem.itemId);
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(backgroundImage: NetworkImage(item.imageUrl)),
                                    title: Text(item.name),
                                    subtitle: Text('${poItem.quantityOrdered} ${item.unit}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.check_circle_outline),
                                      onPressed: () {
                                        // Simulate partial receive or full receive
                                        _showReceiveDialog(context, po, poItem, item);
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReceiveDialog(BuildContext context, PurchaseOrder po, POItem poItem, Item item) {
    final controller = TextEditingController(text: poItem.quantityOrdered.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Receive ${item.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(suffixText: item.unit),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final qty = double.tryParse(controller.text);
              if (qty != null && qty > 0) {
                // Hardcoded warehouse 'w1' for now
                context.read<MockDataService>().receiveGoods(po.id, item.id, qty, 'w1');
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Received $qty ${item.unit} of ${item.name}')),
                );
              }
            },
            child: const Text('Confirm Receipt'),
          ),
        ],
      ),
    );
  }
}
