import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';
import 'package:intl/intl.dart';

class SupplierDashboard extends StatelessWidget {
  const SupplierDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final myQuotes = dataService.quotations.where((q) => q.supplierId == dataService.currentUser?.id).toList();
        final openRFQs = dataService.rfqs.where((r) => r.status == RFQStatus.published && r.isPublic).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Supplier Portal'),
            actions: [
              IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
              IconButton(icon: const Icon(Icons.account_circle), onPressed: () => context.push('/account')),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(context, dataService.currentUser),
                const SizedBox(height: 24),
                
                // KPI Cards
                Row(
                  children: [
                    Expanded(child: _KPICard(title: 'Active Quotes', value: '${myQuotes.length}', icon: Icons.description, color: Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(child: _KPICard(title: 'Win Rate', value: '15%', icon: Icons.trending_up, color: Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(child: _KPICard(title: 'Open RFQs', value: '${openRFQs.length}', icon: Icons.public, color: Colors.orange)),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Marketplace Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('New Opportunities', style: context.textStyles.titleLarge?.bold),
                    TextButton(
                      onPressed: () => context.push('/supplier-shell/marketplace'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (openRFQs.isEmpty)
                  const Center(child: Text('No open RFQs available.'))
                else
                  ...openRFQs.take(3).map((rfq) => _OpportunityCard(rfq: rfq)),

                const SizedBox(height: 32),
                
                // My Quotes Section
                Text('My Recent Quotes', style: context.textStyles.titleLarge?.bold),
                const SizedBox(height: 16),
                 if (myQuotes.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text('You haven\'t submitted any quotes yet.', style: TextStyle(color: Colors.grey[600]))),
                  )
                else
                  ...myQuotes.take(3).map((q) => ListTile(
                    title: Text('Quote #${q.id.substring(0, 8)}'),
                    subtitle: Text('Status: ${q.status.toUpperCase()}'),
                    trailing: Text('\$${q.totalPrice.toStringAsFixed(2)}'),
                  )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, User? user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 24,
            child: Text(
              user?.companyName?.substring(0, 1) ?? 'S',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: context.textStyles.bodyMedium?.copyWith(color: Colors.white70),
              ),
              Text(
                user?.companyName ?? 'Supplier',
                style: context.textStyles.headlineSmall?.bold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KPICard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: context.textStyles.headlineMedium?.bold),
          const SizedBox(height: 4),
          Text(title, style: context.textStyles.bodySmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final RFQ rfq;

  const _OpportunityCard({required this.rfq});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/supplier-shell/rfq/${rfq.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.business_center, color: Colors.orange),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rfq.title, style: context.textStyles.titleMedium?.bold),
                        const SizedBox(height: 4),
                        Text(
                          'Project: ${rfq.projectId} • ${rfq.items.length} Items',
                          style: context.textStyles.bodySmall?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Open',
                      style: context.textStyles.labelSmall?.bold.copyWith(color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deadline: ${DateFormat('MMM d').format(rfq.deadline)}',
                    style: context.textStyles.bodySmall?.copyWith(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () => context.push('/supplier-shell/rfq/${rfq.id}'),
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
