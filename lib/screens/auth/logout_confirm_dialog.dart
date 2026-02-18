import 'package:flutter/material.dart';

class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text('Sign out?', style: ts.titleLarge),
      content: Text('You will need to sign in again to access your workspace.', style: ts.bodyMedium),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Sign out', style: ts.labelLarge?.copyWith(color: cs.onPrimary)),
        ),
      ],
    );
  }
}
