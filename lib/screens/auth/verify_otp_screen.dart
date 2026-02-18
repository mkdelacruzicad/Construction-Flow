import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String? nextPath;
  const VerifyOtpScreen({super.key, this.nextPath});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  int _seconds = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    while (mounted && _seconds > 0) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _seconds--);
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Verify email', style: ts.titleLarge), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Enter the 6-digit code sent to your email', style: ts.bodyLarge),
              const SizedBox(height: 16),
              TextField(controller: _codeCtrl, decoration: const InputDecoration(labelText: 'OTP code', prefixIcon: Icon(Icons.pin)), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              SizedBox(height: 48, child: FilledButton.icon(onPressed: _loading?null:_onVerify, icon: _loading?SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color: cs.onPrimary)):const Icon(Icons.verified), label: Text('Verify', style: ts.labelLarge?.copyWith(color: cs.onPrimary)))),
              const SizedBox(height: 12),
              TextButton(onPressed: _seconds==0?()=> setState(()=> _seconds = 30):null, child: Text(_seconds==0?'Resend code':'Resend in $_seconds s')),
              const SizedBox(height: 8),
              TextButton(onPressed: ()=> context.go('/auth/register'), child: const Text('Change email')),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _onVerify() async {
    setState(()=> _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if(!mounted) return;
    final dest = widget.nextPath ?? '/org/company/select';
    context.go(dest);
  }
}
