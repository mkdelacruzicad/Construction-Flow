import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SupplierProfileSetupScreen extends StatelessWidget {
  const SupplierProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Supplier onboarding')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: ListTile(leading: const Icon(Icons.apartment), title: const Text('Company details'), subtitle: const Text('Name, address, registration'))),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.category), title: const Text('Categories'), subtitle: const Text('Materials & services'))),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.contact_phone), title: const Text('Contacts'), subtitle: const Text('Primary and secondary'))),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.folder_open), title: const Text('Documents'), subtitle: const Text('Certificates & compliance'))),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.insights), title: const Text('Performance'), subtitle: const Text('View your performance scorecard'), onTap: ()=> context.push('/supplier-shell/profile/performance'))),
        const SizedBox(height: 16),
        SizedBox(height: 48, child: FilledButton(onPressed: (){}, child: Text('Save profile', style: ts.labelLarge?.copyWith(color: cs.onPrimary))))
      ]),
    );
  }
}
