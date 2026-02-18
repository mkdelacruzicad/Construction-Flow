import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AwardDecisionScreen extends StatefulWidget {
  final String rfqId;
  const AwardDecisionScreen({super.key, required this.rfqId});

  @override
  State<AwardDecisionScreen> createState() => _AwardDecisionScreenState();
}

class _AwardDecisionScreenState extends State<AwardDecisionScreen> {
  String? _winner;
  final _reasonCtrl = TextEditingController();
  bool _needApproval = false;

  @override
  void dispose() { _reasonCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final vendors = List.generate(4, (i)=> 'Vendor ${i+1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Award decision')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Select winner', prefixIcon: Icon(Icons.emoji_events)),
            items: vendors.map((v)=> DropdownMenuItem(value: v, child: Text(v))).toList(),
            value: _winner,
            onChanged: (v)=> setState(()=> _winner = v),
          ),
          const SizedBox(height: 12),
          TextField(controller: _reasonCtrl, decoration: const InputDecoration(labelText: 'Rejection reasons (optional)', prefixIcon: Icon(Icons.note_alt)), maxLines: 3),
          const SizedBox(height: 12),
          SwitchListTile(value: _needApproval, onChanged: (v)=> setState(()=> _needApproval = v), title: const Text('Require internal approval')),
          const Spacer(),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: _winner==null?null: ()=> context.go('/procurement/rfqs/${widget.rfqId}/create-po'), child: const Text('Proceed to PO'))),
        ]),
      ),
    );
  }
}
