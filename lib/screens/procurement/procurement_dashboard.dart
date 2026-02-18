import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';
import 'package:intl/intl.dart';

class ProcurementDashboard extends StatelessWidget {
  const ProcurementDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final rfqs = dataService.rfqs;
        final pendingRFQs = rfqs.where((r) => r.status == RFQStatus.published).toList();
        final awardedRFQs = rfqs.where((r) => r.status == RFQStatus.awarded).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Procurement Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () => context.push('/account'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsRow(context, pendingRFQs.length, awardedRFQs.length),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active RFQs', style: context.textStyles.titleLarge?.bold),
                    TextButton.icon(
                      onPressed: () => context.push('/procurement-shell/rfq/create'),
                      icon: const Icon(Icons.add),
                      label: const Text('New RFQ'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (pendingRFQs.isEmpty)
                  _buildEmptyState(context, 'No active RFQs')
                else
                  ...pendingRFQs.map((rfq) => _buildRFQCard(context, rfq)),
                  
                const SizedBox(height: 24),
                Text('Recent Purchase Orders', style: context.textStyles.titleLarge?.bold),
                const SizedBox(height: 16),
                // Placeholder for POs
                _buildEmptyState(context, 'No recent Purchase Orders'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/procurement-shell/rfq/create'),
            icon: const Icon(Icons.add),
            label: const Text('Create RFQ'),
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(BuildContext context, int activeCount, int awardedCount) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Active RFQs',
            value: activeCount.toString(),
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.assignment,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Awarded',
            value: awardedCount.toString(),
            color: Theme.of(context).colorScheme.secondary,
            icon: Icons.check_circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Pending POs',
            value: '0',
            color: Theme.of(context).colorScheme.tertiary,
            icon: Icons.pending_actions,
          ),
        ),
      ],
    );
  }

  Widget _buildRFQCard(BuildContext context, RFQ rfq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rfq.title,
                    style: context.textStyles.titleMedium?.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    rfq.status.name.toUpperCase(),
                    style: context.textStyles.labelSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Project: ${rfq.projectId}',
              style: context.textStyles.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  'Deadline: ${DateFormat('MMM d, yyyy').format(rfq.deadline)}',
                  style: context.textStyles.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const Spacer(),
                Text(
                  '${rfq.items.length} Items',
                  style: context.textStyles.labelMedium?.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.textStyles.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: context.textStyles.headlineMedium?.bold.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: context.textStyles.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
