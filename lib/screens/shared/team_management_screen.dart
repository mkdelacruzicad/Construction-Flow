import 'package:flutter/material.dart';

class TeamManagementScreen extends StatelessWidget {
  const TeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final members = List.generate(6, (i)=> {'name':'Member ${i+1}','role': ['Admin','Procurement','Warehouse','Supplier'][i%4]});
    return Scaffold(
      appBar: AppBar(title: const Text('Team management')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(child: ListTile(leading: const Icon(Icons.person_add), title: const Text('Invite users'), trailing: const Icon(Icons.chevron_right), onTap: (){})),
          const SizedBox(height: 8),
          ...members.map((m)=> Card(child: ListTile(leading: const Icon(Icons.person), title: Text(m['name'] as String), subtitle: Text(m['role'] as String), trailing: const Icon(Icons.edit))))
        ],
      ),
    );
  }
}
