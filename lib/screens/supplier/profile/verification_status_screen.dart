import 'package:flutter/material.dart';

class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Verification status')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.verified, color: cs.primary, size: 64),
        const SizedBox(height: 8),
        Text('Pending verification', style: ts.titleLarge),
        const SizedBox(height: 8),
        Text('Our team will verify your documents within 2-3 days.', style: ts.bodyMedium),
      ])),
    );
  }
}
