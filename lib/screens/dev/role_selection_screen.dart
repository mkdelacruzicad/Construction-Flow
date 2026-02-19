import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:siteflow/services/app_state.dart';
import 'package:siteflow/theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text('ConstructFlow', style: context.textStyles.displaySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Select your role to continue', style: context.textStyles.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.75)), textAlign: TextAlign.center),
                const SizedBox(height: 48),
                _RoleCard(
                  title: 'Procurement Officer',
                  description: 'Manage RFQs, Purchase Orders, and Suppliers',
                  icon: Icons.assignment_ind,
                  onTap: () {
                    _selectRole(context, 'procurement');
                  },
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  title: 'Supplier',
                  description: 'Browse RFQs, Submit Quotes, Manage Catalog',
                  icon: Icons.storefront,
                  onTap: () {
                    _selectRole(context, 'supplier');
                  },
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  title: 'Warehouse Manager',
                  description: 'Track Inventory, Receive Goods, Dispatch',
                  icon: Icons.warehouse,
                  onTap: () {
                    _selectRole(context, 'warehouse');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectRole(BuildContext context, String role) {
    final app = context.read<AppState>();
    app.setRole(role);

    // If fully authenticated and org set, jump straight to the shell for quick testing
    if (app.isLoggedIn && app.companyId != null && app.projectId != null) {
      final dest = switch (role) {
        'procurement' => '/procurement-shell/dashboard',
        'supplier' => '/supplier-shell/dashboard',
        'warehouse' => '/warehouse-shell/dashboard',
        _ => '/procurement-shell/dashboard',
      };
      context.go(dest);
      return;
    }

    // Otherwise, keep normal flow: if logged in but missing org, go to selectors; else go to login
    if (app.isLoggedIn) {
      if (app.companyId == null) {
        context.go('/org/company/select');
      } else {
        context.go('/org/project/select');
      }
    } else {
      context.push('/auth/login');
    }
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({required this.title, required this.description, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: context.textStyles.titleLarge?.bold),
                  const SizedBox(height: 4),
                  Text(description, style: context.textStyles.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ]),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
