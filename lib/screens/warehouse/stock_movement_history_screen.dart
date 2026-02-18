import 'package:flutter/material.dart';

class StockMovementHistoryScreen extends StatelessWidget {
  const StockMovementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(20, (i)=> {'time':'2025-06-1${i}', 'desc': i%2==0? 'Received from PO-20$i' : 'Dispatched for site'});
    return Scaffold(
      appBar: AppBar(title: const Text('Stock movement history')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i){
          final it = items[i];
          return ListTile(leading: const Icon(Icons.timeline), title: Text(it['desc'] as String), subtitle: Text(it['time'] as String));
        },
      ),
    );
  }
}
