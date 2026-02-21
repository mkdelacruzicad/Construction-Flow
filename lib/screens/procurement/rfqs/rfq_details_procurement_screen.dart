import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RFQDetailsProcurementScreen extends StatelessWidget {
  final String rfqId;
  const RFQDetailsProcurementScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('RFQ $rfqId', style: ts.titleLarge), actions: [
        IconButton(onPressed: ()=> context.push('/procurement-shell/rfqs/$rfqId/invite'), icon: const Icon(Icons.group_add)),
        IconButton(onPressed: ()=> context.push('/procurement-shell/rfqs/$rfqId/submissions'), icon: const Icon(Icons.inbox)),
        IconButton(onPressed: ()=> context.push('/procurement-shell/rfqs/$rfqId/compare'), icon: const Icon(Icons.table_chart)),
        IconButton(onPressed: ()=> context.push('/procurement-shell/rfqs/$rfqId/decision-board'), icon: const Icon(Icons.insights)),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Section(title: 'Overview'),
          SizedBox(height: 12),
          _Section(title: 'Line items / BOQ summary'),
          SizedBox(height: 12),
          _Section(title: 'Invited vendors'),
          SizedBox(height: 12),
          _Section(title: 'Submission statuses'),
          SizedBox(height: 12),
          _Section(title: 'Documents'),
          SizedBox(height: 12),
          _Section(title: 'Activity timeline'),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children:[
          OutlinedButton(onPressed: (){}, child: const Text('Edit')),
          const SizedBox(width: 8),
          FilledButton(onPressed: (){}, child: const Text('Publish')),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: (){}, child: const Text('Close')),
          const Spacer(),
          FilledButton.tonal(onPressed: ()=> context.push('/procurement-shell/rfqs/$rfqId/create-po'), child: const Text('Create PO')),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(title)));
  }
}
