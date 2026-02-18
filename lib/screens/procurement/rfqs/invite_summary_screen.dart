import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InviteSummaryScreen extends StatelessWidget {
  final String rfqId;
  const InviteSummaryScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Invite summary', style: ts.titleLarge)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(child: ListTile(title: const Text('Deadline'), subtitle: const Text('2025-06-30 17:00'))),
            const SizedBox(height: 8),
            Card(child: ListTile(title: const Text('Message'), subtitle: const Text('Please submit your best quote.'))),
            const SizedBox(height: 8),
            Card(child: ListTile(title: const Text('Attachments'), subtitle: const Text('BOQ.pdf, Drawings.zip'))),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton(onPressed: ()=> context.go('/procurement-shell/rfqs/$rfqId/invite/success'), child: const Text('Send invites')),
      ),
    );
  }
}
