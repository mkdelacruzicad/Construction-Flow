import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  DateTimeRange? _dates;
  String _currency = 'USD';
  final _budgetCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() { _nameCtrl.dispose(); _locationCtrl.dispose(); _budgetCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Create project', style: ts.titleLarge)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Project name', prefixIcon: Icon(Icons.work_outline)), validator: (v)=> (v==null||v.isEmpty)?'Required':null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _locationCtrl, decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.place_outlined))),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.date_range),
                    title: Text(_dates==null? 'Select dates' : '${_dates!.start.toLocal().toString().split(' ').first} → ${_dates!.end.toLocal().toString().split(' ').first}'),
                    onTap: () async {
                      final now = DateTime.now();
                      final range = await showDateRangePicker(context: context, firstDate: DateTime(now.year-1), lastDate: DateTime(now.year+2));
                      if(range!=null) setState(()=> _dates = range);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Currency', prefixIcon: Icon(Icons.attach_money)),
                    value: _currency,
                    items: const [
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                      DropdownMenuItem(value: 'AED', child: Text('AED')),
                    ],
                    onChanged: (v)=> setState(()=> _currency = v ?? 'USD'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _budgetCtrl, decoration: const InputDecoration(labelText: 'Optional budget', prefixIcon: Icon(Icons.account_balance_wallet_outlined)), keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  SizedBox(height: 48, child: FilledButton(onPressed: _loading?null:_onCreate, child: _loading?SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color: cs.onPrimary)):Text('Create project', style: ts.labelLarge?.copyWith(color: cs.onPrimary)))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onCreate() async {
    if(!_formKey.currentState!.validate()) return;
    setState(()=> _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if(!mounted) return; context.go('/org/project/select');
  }
}
