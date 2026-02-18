import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JoinCompanyScreen extends StatefulWidget {
  const JoinCompanyScreen({super.key});

  @override
  State<JoinCompanyScreen> createState() => _JoinCompanyScreenState();
}

class _JoinCompanyScreenState extends State<JoinCompanyScreen> {
  final _codeCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() { _codeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Join company', style: ts.titleLarge)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: _codeCtrl, decoration: const InputDecoration(labelText: 'Invite code', prefixIcon: Icon(Icons.key))),
              const SizedBox(height: 12),
              SizedBox(height: 48, child: FilledButton.icon(onPressed: _sending?null:_onRequest, icon: _sending?SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color: cs.onPrimary)):const Icon(Icons.how_to_reg), label: Text('Request to join', style: ts.labelLarge?.copyWith(color: cs.onPrimary)))),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _onRequest() async {
    setState(()=> _sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if(!mounted) return; context.go('/org/company/pending');
  }
}
