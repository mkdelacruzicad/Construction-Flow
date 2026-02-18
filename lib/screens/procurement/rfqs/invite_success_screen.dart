import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InviteSuccessScreen extends StatelessWidget {
  final String rfqId;
  const InviteSuccessScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Invites sent')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.mark_email_read, color: cs.primary, size: 64),
          const SizedBox(height: 8),
          Text('Invites sent successfully', style: ts.titleLarge),
          const SizedBox(height: 16),
          FilledButton(onPressed: ()=> context.go('/procurement/rfqs/$rfqId'), child: const Text('Back to RFQ')),
        ]),
      ),
    );
  }
}
