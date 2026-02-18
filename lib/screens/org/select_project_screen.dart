import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:siteflow/services/app_state.dart';

class SelectProjectScreen extends StatefulWidget {
  const SelectProjectScreen({super.key});

  @override
  State<SelectProjectScreen> createState() => _SelectProjectScreenState();
}

class _SelectProjectScreenState extends State<SelectProjectScreen> {
  final _searchCtrl = TextEditingController();
  int _filterIdx = 0; // 0 Active, 1 Archived
  final _projects = List.generate(8, (i) => {'id': 'p$i', 'name': 'Project ${i+1}', 'status': i%4==0?'Archived':'Active', 'location': 'Site ${i+1}'});

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select project', style: ts.titleLarge),
        actions: [TextButton.icon(onPressed: () => context.push('/org/project/create'), icon: const Icon(Icons.add_location_alt), label: const Text('New'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(controller: _searchCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search projects')),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [ButtonSegment(value: 0, label: Text('Active')), ButtonSegment(value: 1, label: Text('Archived'))],
            selected: {_filterIdx},
            onSelectionChanged: (s) => setState(()=> _filterIdx = s.first),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _projects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final p = _projects[i];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(p['name'] as String),
                    subtitle: Text(p['location'] as String),
                    trailing: Text(p['status'] as String),
                    onTap: () {
                      context.read<AppState>().selectProject(p['id'] as String);
                      final role = context.read<AppState>().role ?? 'procurement';
                      final dest = switch (role) {
                        'procurement' => '/procurement-shell/dashboard',
                        'supplier' => '/supplier-shell/dashboard',
                        'warehouse' => '/warehouse-shell/dashboard',
                        _ => '/procurement-shell/dashboard'
                      };
                      context.go(dest);
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
