import 'package:flutter/material.dart';

class PutawayTaskDetailScreen extends StatelessWidget {
  final String taskId;
  const PutawayTaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Putaway Task $taskId')),
      body: ListView(padding: const EdgeInsets.all(12), children: const [
        _Section(title: 'Source dock'),
        SizedBox(height: 8),
        _Section(title: 'Destination bin'),
        SizedBox(height: 8),
        _Section(title: 'Items'),
      ]),
      bottomNavigationBar: Padding(padding: const EdgeInsets.all(12), child: FilledButton(onPressed: (){}, child: const Text('Mark complete'))),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(title)));
}
