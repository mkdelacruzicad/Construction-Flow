import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReceiveAgainstPOScreen extends StatelessWidget {
  final String poId;
  const ReceiveAgainstPOScreen({super.key, required this.poId});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(6, (i)=> {'name':'Item ${i+1}','ordered': 10+i, 'received': 0});
    return Scaffold(
      appBar: AppBar(title: Text('Receive $poId')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        ...items.map((it)=> Card(child: ListTile(
          title: Text(it['name'].toString()),
          subtitle: Text('Ordered: ${it['ordered']}'),
          trailing: SizedBox(width: 120, child: TextField(decoration: const InputDecoration(labelText: 'Received'), keyboardType: TextInputType.number)),
        ))),
        const SizedBox(height: 8),
        ListTile(leading: const Icon(Icons.report_problem), title: const Text('Damaged / Missing'), trailing: const Icon(Icons.chevron_right), onTap: (){}),
        const SizedBox(height: 8),
        ListTile(leading: const Icon(Icons.upload_file), title: const Text('Upload delivery note')),        
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton(onPressed: ()=> context.go('/warehouse-shell/receiving/$poId/grn'), child: const Text('Generate GRN')),
      ),
    );
  }
}
