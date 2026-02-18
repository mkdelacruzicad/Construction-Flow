import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class POListScreen extends StatelessWidget {
  const POListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = ['Issued','Acknowledged','In Transit','Partial','Received'];
    final items = List.generate(12, (i)=> {'id':'PO-10$i','status': statuses[i%5], 'amount': '\$${(i+1)*5000}'});
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Orders')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i){
          final po = items[i];
          return Card(child: ListTile(
            title: Text(po['id'] as String),
            subtitle: Text(po['status'] as String),
            trailing: Text(po['amount'] as String),
            onTap: ()=> context.push('/procurement-shell/pos/${po['id']}'),
          ));
        },
      ),
    );
  }
}
