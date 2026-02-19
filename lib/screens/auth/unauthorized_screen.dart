import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:siteflow/services/app_state.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    final role = context.watch<AppState>().role ?? 'procurement';
    final dest = switch (role) {
      'procurement' => '/procurement-shell/dashboard',
      'supplier' => '/supplier-shell/dashboard',
      'warehouse' => '/warehouse-shell/dashboard',
      _ => '/procurement-shell/dashboard',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Unauthorized')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 72, color: cs.error),
                const SizedBox(height: 16),
                Text('Access denied', style: ts.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'You don\'t have permission to view this section. Your account role does not allow access to this area.',
                  style: ts.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: () => context.go(dest),
                    icon: Icon(Icons.space_dashboard, color: cs.onPrimary),
                    label: Text('Go to my dashboard', style: ts.labelLarge?.copyWith(color: cs.onPrimary)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
