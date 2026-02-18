import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Forgot password', style: ts.titleLarge)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Enter your email to receive a reset code', style: ts.bodyLarge),
              const SizedBox(height: 16),
              TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail)), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              SizedBox(height: 48, child: FilledButton.icon(onPressed: _loading?null:_onSend, icon: _loading?SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color: cs.onPrimary)):const Icon(Icons.send), label: Text('Send reset code', style: ts.labelLarge?.copyWith(color: cs.onPrimary)))),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _onSend() async {
    setState(()=> _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if(!mounted) return;
    context.go('/auth/reset-password');
  }
}
