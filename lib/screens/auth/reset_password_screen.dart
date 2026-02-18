import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _success = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Reset password', style: ts.titleLarge)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _success
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_circle, color: cs.primary, size: 56),
                    const SizedBox(height: 8),
                    Text('Password updated successfully', style: ts.titleLarge),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: () => context.go('/auth/login'), child: const Text('Back to sign in')),
                  ])
                : Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'New password', prefixIcon: Icon(Icons.lock)), obscureText: true),
                    const SizedBox(height: 12),
                    TextField(controller: _confirmCtrl, decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.lock_reset)), obscureText: true),
                    const SizedBox(height: 16),
                    SizedBox(height: 48, child: FilledButton.icon(onPressed: _loading?null:_onReset, icon: _loading?SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color: cs.onPrimary)):const Icon(Icons.check), label: Text('Update password', style: ts.labelLarge?.copyWith(color: cs.onPrimary)))),
                  ]),
          ),
        ),
      ),
    );
  }

  Future<void> _onReset() async {
    if (_passCtrl.text.length < 6 || _passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords must match and be at least 6 characters')));
      return;
    }
    setState(()=> _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if(!mounted) return;
    setState(() { _loading = false; _success = true; });
  }
}
