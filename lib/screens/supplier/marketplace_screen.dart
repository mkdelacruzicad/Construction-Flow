import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';
import 'package:intl/intl.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final rfqs = dataService.rfqs.where((r) => r.status == RFQStatus.published && r.isPublic).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('RFQ Marketplace')),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rfqs.length,
            itemBuilder: (context, index) {
              final rfq = rfqs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(rfq.title, style: context.textStyles.titleMedium?.bold),
                  subtitle: Text('Deadline: ${DateFormat('yyyy-MM-dd').format(rfq.deadline)} • ${rfq.items.length} items'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/supplier/rfq/${rfq.id}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
