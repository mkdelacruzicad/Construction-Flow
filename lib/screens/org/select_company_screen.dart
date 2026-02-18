import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:siteflow/services/app_state.dart';

class SelectCompanyScreen extends StatefulWidget {
  const SelectCompanyScreen({super.key});

  @override
  State<SelectCompanyScreen> createState() => _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  final _searchCtrl = TextEditingController();
  final _companies = List.generate(6, (i) => {'id': 'c$i', 'name': 'Company ${i+1}', 'country': 'Country ${i+1}'});

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select company', style: ts.titleLarge),
        actions: [TextButton.icon(onPressed: () => context.push('/org/company/create'), icon: const Icon(Icons.add_business), label: const Text('Create'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _searchCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search companies or invite code')),
          const SizedBox(height: 12),
          Row(children: [
            OutlinedButton.icon(onPressed: ()=> context.push('/org/company/join'), icon: const Icon(Icons.qr_code), label: const Text('Join by invite')),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: _companies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final c = _companies[i];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.apartment)),
                    title: Text(c['name'] as String),
                    subtitle: Text(c['country'] as String),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.read<AppState>().selectCompany(c['id'] as String);
                      context.go('/org/project/select');
                    },
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
