import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectPOToReceiveScreen extends StatelessWidget {
  const SelectPOToReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10, (i)=> {'id': 'PO-20$i', 'vendor':'Vendor ${i+1}', 'eta':'2025-06-${10+i}'});
    return Scaffold(
      appBar: AppBar(title: const Text('Select PO to receive')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i){
          final it = items[i];
          return Card(child: ListTile(
            title: Text(it['id'] as String),
            subtitle: Text('${it['vendor']} • ETA ${it['eta']}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()=> context.push('/warehouse/receiving/${it['id']}'),
          ));
        },
      ),
    );
  }
}
