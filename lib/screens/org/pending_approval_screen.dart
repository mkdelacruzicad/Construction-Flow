import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Pending approval', style: ts.titleLarge)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.hourglass_top, size: 64, color: cs.primary),
              const SizedBox(height: 12),
              Text('Your request is pending admin approval', style: ts.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('We will notify you once approved. You can also contact your workspace admin.', style: ts.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.mail_outline), label: const Text('Contact admin')),
              const SizedBox(height: 8),
              TextButton(onPressed: ()=> context.go('/auth/login'), child: const Text('Back to sign in')),
            ]),
          ),
        ),
      ),
    );
  }
}
