import 'package:flutter/material.dart';

class GRNSummaryScreen extends StatelessWidget {
  final String poId;
  const GRNSummaryScreen({super.key, required this.poId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('GRN Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(child: ListTile(title: Text('PO $poId'), subtitle: const Text('Receipt summary'))),
          const SizedBox(height: 8),
          Expanded(child: Card(child: Center(child: Text('Items & quantities')))),
          const SizedBox(height: 8),
          Card(child: SizedBox(height: 120, child: Center(child: Text('Signature placeholder', style: TextStyle(color: cs.onSurfaceVariant))))),
        ]),
      ),
    );
  }
}
