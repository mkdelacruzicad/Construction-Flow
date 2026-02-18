import 'package:flutter/material.dart';

class CreatePOFromAwardScreen extends StatefulWidget {
  final String rfqId;
  const CreatePOFromAwardScreen({super.key, required this.rfqId});

  @override
  State<CreatePOFromAwardScreen> createState() => _CreatePOFromAwardScreenState();
}

class _CreatePOFromAwardScreenState extends State<CreatePOFromAwardScreen> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _StepCard(title: 'Vendor', child: const ListTile(title: Text('Vendor 1'), subtitle: Text('Selected winner'))),
      _StepCard(title: 'Terms', child: const ListTile(title: Text('Net 30'), subtitle: Text('Standard payment terms'))),
      _StepCard(title: 'Schedule', child: const ListTile(title: Text('Delivery by 2025-07-10'))),
      _StepCard(title: 'Review', child: const ListTile(title: Text('Review summary'), subtitle: Text('Line items and totals'))),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Create PO from ${widget.rfqId}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: List.generate(steps.length, (i)=> Expanded(child: LinearProgressIndicator(value: i<=_step?1:0, minHeight: 4))).expand((w)=> [Expanded(child:w), const SizedBox(width: 6)]).toList()..removeLast()),
          const SizedBox(height: 16),
          Expanded(child: steps[_step]),
          const SizedBox(height: 12),
          Row(children:[
            OutlinedButton(onPressed: _step==0?null: ()=> setState(()=> _step--), child: const Text('Back')),
            const Spacer(),
            FilledButton(onPressed: _step==steps.length-1? ()=> _issuePO(context) : ()=> setState(()=> _step++), child: Text(_step==steps.length-1?'Issue PO':'Next')),
          ])
        ]),
      ),
    );
  }

  void _issuePO(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PO issued')));
    Navigator.of(context).pop();
  }
}

class _StepCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _StepCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 8), child])));
}
