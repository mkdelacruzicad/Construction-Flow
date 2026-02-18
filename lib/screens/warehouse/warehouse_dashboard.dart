import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';

class WarehouseDashboard extends StatelessWidget {
  const WarehouseDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final inventory = dataService.inventory;
        final lowStock = inventory.where((i) => i.quantityOnHand <= i.minStockLevel).toList();
        final pendingPOs = dataService.purchaseOrders.where((po) => po.status == POStatus.issued).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Warehouse Operations'),
            actions: [
              IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () {}),
              IconButton(icon: const Icon(Icons.account_circle), onPressed: () => context.push('/account')),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Low Stock Alerts',
                        value: lowStock.length.toString(),
                        color: Theme.of(context).colorScheme.error,
                        icon: Icons.warning_amber,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'Pending Receipts',
                        value: pendingPOs.length.toString(),
                        color: Theme.of(context).colorScheme.secondary,
                        icon: Icons.local_shipping,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Quick Actions Grid
                Text('Quick Actions', style: context.textStyles.titleLarge?.bold),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.8,
                  children: [
                    _ActionButton(label: 'Receive', icon: Icons.download_rounded, onTap: () => context.push('/warehouse-shell/receiving')),
                    _ActionButton(label: 'Dispatch', icon: Icons.upload_rounded, onTap: () => context.push('/warehouse-shell/dispatch')),
                    _ActionButton(label: 'Inventory', icon: Icons.inventory_2_outlined, onTap: () => context.push('/warehouse-shell/inventory')),
                    _ActionButton(label: 'Transfer', icon: Icons.compare_arrows_rounded, onTap: () => context.push('/warehouse-shell/transfer')),
                    _ActionButton(label: 'Cycle Count', icon: Icons.fact_check_outlined, onTap: () => context.push('/warehouse-shell/cycle-count')),
                    _ActionButton(label: 'Putaway', icon: Icons.grid_view_outlined, onTap: () => context.push('/warehouse-shell/putaway')),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Inventory List
                Text('Current Inventory', style: context.textStyles.titleLarge?.bold),
                const SizedBox(height: 16),
                
                if (inventory.isEmpty)
                  const Center(child: Text('No inventory records found.'))
                else
                  ...inventory.map((inv) {
                    final item = dataService.items.firstWhere((i) => i.id == inv.itemId);
                    final isLow = inv.quantityOnHand <= inv.minStockLevel;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item.imageUrl),
                          backgroundColor: Colors.grey[200],
                        ),
                        title: Text(item.name),
                        subtitle: Text('Location: Warehouse 1'), // Simplified
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Text(
                               '${inv.quantityOnHand.toInt()} ${item.unit}',
                               style: context.textStyles.titleMedium?.bold.copyWith(
                                 color: isLow ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface,
                               ),
                             ),
                            if (isLow)
                              Text('Low Stock', style: context.textStyles.labelSmall?.copyWith(color: Theme.of(context).colorScheme.error)),
                          ],
                        ),
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
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: context.textStyles.headlineMedium?.bold.copyWith(color: color)),
              Text(title, style: context.textStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium?.bold)),
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
