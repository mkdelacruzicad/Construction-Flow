import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';
import 'package:intl/intl.dart';

class RFQDetailsScreen extends StatelessWidget {
  final String rfqId;

  const RFQDetailsScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final rfq = dataService.rfqs.firstWhere((r) => r.id == rfqId, orElse: () => throw Exception('RFQ not found'));
        final items = rfq.items.map((ri) {
          final item = dataService.items.firstWhere((i) => i.id == ri.itemId);
          return _RFQItemViewModel(item, ri);
        }).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('RFQ Details')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rfq.title, style: context.textStyles.headlineSmall?.bold),
                const SizedBox(height: 8),
                Text('Project: ${rfq.projectId}', style: context.textStyles.titleMedium?.copyWith(color: Colors.grey[600])),
                const SizedBox(height: 16),
                _StatusBadge(status: rfq.status),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text('Items Requested', style: context.textStyles.titleLarge?.bold),
                const SizedBox(height: 16),
                ...items.map((vm) => _ItemCard(viewModel: vm)),
                const SizedBox(height: 32),
                if (rfq.status == RFQStatus.published)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/supplier-shell/rfq/$rfqId/quote'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Submit Quotation'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RFQStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case RFQStatus.draft: color = Colors.grey; break;
      case RFQStatus.published: color = Colors.green; break;
      case RFQStatus.closed: color = Colors.red; break;
      case RFQStatus.awarded: color = Colors.blue; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final _RFQItemViewModel viewModel;
  const _ItemCard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(viewModel.item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(viewModel.item.name, style: context.textStyles.titleMedium?.bold),
                  Text('Quantity: ${viewModel.rfqItem.quantity} ${viewModel.item.unit}'),
                  if (viewModel.rfqItem.specifications != null)
                    Text('Spec: ${viewModel.rfqItem.specifications}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RFQItemViewModel {
  final Item item;
  final RFQItem rfqItem;
  _RFQItemViewModel(this.item, this.rfqItem);
}
