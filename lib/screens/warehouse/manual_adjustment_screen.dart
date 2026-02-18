import 'package:flutter/material.dart';

class ManualAdjustmentScreen extends StatefulWidget {
  const ManualAdjustmentScreen({super.key});

  @override
  State<ManualAdjustmentScreen> createState() => _ManualAdjustmentScreenState();
}

class _ManualAdjustmentScreenState extends State<ManualAdjustmentScreen> {
  final _qtyCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  @override
  void dispose() { _qtyCtrl.dispose(); _reasonCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Manual adjustment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          TextField(decoration: const InputDecoration(labelText: 'Item', prefixIcon: Icon(Icons.search))),
          const SizedBox(height: 12),
          TextField(controller: _qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity (+/-)', prefixIcon: Icon(Icons.exposure)), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _reasonCtrl, decoration: const InputDecoration(labelText: 'Reason (required)', prefixIcon: Icon(Icons.report_problem)), maxLines: 3),
          const SizedBox(height: 16),
          SizedBox(height: 48, child: FilledButton(onPressed: (){}, child: Text('Submit adjustment', style: ts.labelLarge?.copyWith(color: cs.onPrimary))))
        ]),
      ),
    );
  }
}
