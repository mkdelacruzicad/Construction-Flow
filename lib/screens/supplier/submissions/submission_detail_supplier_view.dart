import 'package:flutter/material.dart';

class SubmissionDetailSupplierView extends StatelessWidget {
  final String submissionId;
  const SubmissionDetailSupplierView({super.key, required this.submissionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submission $submissionId')),
      body: ListView(padding: const EdgeInsets.all(12), children: const [
        _Section(title: 'Quote details'),
        SizedBox(height: 8),
        _Section(title: 'Line items'),
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
