import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VendorListScreen extends StatelessWidget {
  const VendorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vendors = List.generate(20, (i)=> {'name': 'Vendor ${i+1}', 'category': ['Concrete','Metal','Electrical'][i%3]});
    return Scaffold(
      appBar: AppBar(title: const Text('Vendors')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: vendors.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i){
          final v = vendors[i];
          final vendorId = 'v${i+1}';
          return Card(child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.store)),
            title: Text(v['name'] as String),
            subtitle: Text(v['category'] as String),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              TextButton.icon(onPressed: ()=> context.push('/procurement-shell/vendors/$vendorId/scorecard'), icon: const Icon(Icons.insights), label: const Text('Scorecard')),
              const Icon(Icons.chevron_right),
            ]),
            onTap: (){},
          ));
        },
      ),
    );
  }
}
