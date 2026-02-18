import 'package:flutter/material.dart';

class PODetailsScreen extends StatelessWidget {
  final String poId;
  const PODetailsScreen({super.key, required this.poId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PO $poId')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _Section(title: 'Items & received qty'),
          SizedBox(height: 8),
          _Section(title: 'Delivery info'),
          SizedBox(height: 8),
          _Section(title: 'Attachments'),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(title)));
}
