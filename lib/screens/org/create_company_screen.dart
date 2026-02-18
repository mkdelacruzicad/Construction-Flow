import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _industryCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _countryCtrl.dispose();
    _industryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Create company', style: ts.titleLarge)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Company name', prefixIcon: Icon(Icons.apartment)), validator: (v)=> (v==null||v.isEmpty)?'Required':null),
                const SizedBox(height: 12),
                TextFormField(controller: _countryCtrl, decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Icons.public))),
                const SizedBox(height: 12),
                TextFormField(controller: _industryCtrl, decoration: const InputDecoration(labelText: 'Industry', prefixIcon: Icon(Icons.factory))),
                const SizedBox(height: 12),
                Container(
                  height: 72,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outline.withValues(alpha: 0.2))),
                  alignment: Alignment.center,
                  child: Text('Logo placeholder', style: ts.labelLarge),
                ),
                const SizedBox(height: 16),
                SizedBox(height: 48, child: FilledButton(onPressed: _loading?null:_onCreate, child: _loading?SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color: cs.onPrimary)):Text('Create company', style: ts.labelLarge?.copyWith(color: cs.onPrimary)))),
              ]),
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
    if(!mounted) return; context.go('/org/company/pending');
  }
}
