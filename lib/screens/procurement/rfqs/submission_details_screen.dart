import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubmissionDetailsScreen extends StatelessWidget {
  final String rfqId;
  final String vendorId;
  const SubmissionDetailsScreen({super.key, required this.rfqId, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submission - $vendorId'), actions: [
        IconButton(onPressed: ()=> context.push('/procurement-shell/vendors/$vendorId/scorecard'), icon: const Icon(Icons.insights)),
      ]),
      body: ListView(padding: const EdgeInsets.all(12), children: const [
        _Section(title: 'Quote summary'),
        SizedBox(height: 8),
        _Section(title: 'Line items'),
        SizedBox(height: 8),
        _Section(title: 'Documents'),
        SizedBox(height: 8),
        _Section(title: 'Notes thread'),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(title)));
}
