import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:siteflow/models/data_models.dart';
import 'package:siteflow/services/mock_data_service.dart';
import 'package:siteflow/nav.dart';
import 'package:siteflow/theme.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.procurement:
        return 'Procurement Officer';
      case UserRole.supplier:
        return 'Supplier';
      case UserRole.warehouse:
        return 'Warehouse Manager';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MockDataService>();
    final user = data.currentUser;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: scheme.primary.withValues(alpha: 0.12),
                    child: Icon(Icons.person, color: scheme.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Guest User', style: Theme.of(context).textTheme.titleLarge?.bold),
                        const SizedBox(height: 4),
                        Text(user?.email ?? 'guest@example.com', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            user != null ? _roleLabel(user.role) : 'Not Signed In',
                            style: Theme.of(context).textTheme.labelSmall?.bold.copyWith(color: scheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Details Card (extensible for later fields)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(icon: Icons.badge_outlined, label: 'Name', value: user?.name ?? '-'),
                    const Divider(height: 24),
                    _DetailRow(icon: Icons.email_outlined, label: 'Email', value: user?.email ?? '-'),
                    const Divider(height: 24),
                    _DetailRow(icon: Icons.work_outline, label: 'Role', value: user != null ? _roleLabel(user.role) : '-'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Logout
            FilledButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(scheme.errorContainer),
                foregroundColor: MaterialStatePropertyAll(scheme.onErrorContainer),
              ),
              onPressed: () {
                context.read<MockDataService>().logout();
                context.go(AppRoutes.home);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: scheme.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
