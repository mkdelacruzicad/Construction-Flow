import 'package:flutter/material.dart';

class LocationsAndBinsScreen extends StatelessWidget {
  const LocationsAndBinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bins = List.generate(20, (i)=> {'loc': 'Aisle ${i%5+1}', 'bin': 'Bin ${i+1}', 'items': (i+1)*3});
    return Scaffold(
      appBar: AppBar(title: const Text('Locations & Bins')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: bins.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i){
          final b = bins[i];
          return Card(child: ListTile(
            leading: const Icon(Icons.grid_view),
            title: Text('${b['loc']} - ${b['bin']}'),
            subtitle: Text('Items: ${b['items']}'),
          ));
        },
      ),
    );
  }
}
