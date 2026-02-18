import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RFQSubmissionsScreen extends StatelessWidget {
  final String rfqId;
  const RFQSubmissionsScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    final statuses = ['Not started','In progress','Submitted','Late'];
    final vendors = List.generate(10, (i) => {'id': 'v$i','name': 'Vendor ${i+1}','status': statuses[i%4]});
    return Scaffold(
      appBar: AppBar(title: const Text('Submissions')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: vendors.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i){
          final v = vendors[i];
          return Card(
            child: ListTile(
              title: Text(v['name'] as String),
              subtitle: Text(v['status'] as String),
              trailing: const Icon(Icons.chevron_right),
              onTap: ()=> context.push('/procurement/rfqs/$rfqId/submissions/${v['id']}'),
            ),
          );
        },
      ),
    );
  }
}
