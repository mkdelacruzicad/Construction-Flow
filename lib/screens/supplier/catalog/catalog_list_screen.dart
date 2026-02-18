import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CatalogListScreen extends StatelessWidget {
  const CatalogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(15, (i)=> {'id':'I${i+1}','name':'Item ${i+1}','price':'\$${(i+1)*10}'});
    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i){
          final it = items[i];
          return Card(child: ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(it['name'] as String),
            trailing: Text(it['price'] as String),
            onTap: ()=> context.push('/supplier/catalog/${it['id']}'),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=> context.push('/supplier/catalog/new'), icon: const Icon(Icons.add), label: const Text('Add item')),
    );
  }
}
