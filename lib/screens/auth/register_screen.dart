import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:siteflow/services/app_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _role = 'procurement';
  bool _agree = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Create account', style: ts.titleLarge), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('Join Construction-Flow', style: ts.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person)), validator: (v) => (v==null||v.isEmpty)?'Required':null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Work email', prefixIcon: Icon(Icons.mail)), keyboardType: TextInputType.emailAddress, validator: (v){ if(v==null||v.isEmpty) return 'Required'; if(!v.contains('@')) return 'Enter a valid email'; return null; }),
                    const SizedBox(height: 12),
                    TextFormField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone)), keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: const InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.badge)),
                      items: const [
                        DropdownMenuItem(value: 'procurement', child: Text('Procurement')),
                        DropdownMenuItem(value: 'supplier', child: Text('Supplier')),
                        DropdownMenuItem(value: 'warehouse', child: Text('Warehouse')),
                      ],
                      onChanged: (v) => setState(() => _role = v ?? 'procurement'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(controller: _passwordCtrl, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)), obscureText: true, validator: (v)=> (v==null||v.length<6)?'Min 6 chars':null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _confirmCtrl, decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.lock_reset)), obscureText: true, validator: (v)=> (v!=_passwordCtrl.text)?'Passwords do not match':null),
                    const SizedBox(height: 8),
                    Row(children:[
                      Checkbox(value: _agree, onChanged: (v)=> setState(()=> _agree = v??false)),
                      const SizedBox(width: 4),
                      Expanded(child: Text('I agree to the Terms of Service and Privacy Policy', style: ts.labelMedium?.copyWith(color: cs.onSurfaceVariant))),
                    ]),
                  ]),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: (!_agree || _loading) ? null : _onRegister,
                    icon: _loading ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: cs.onPrimary)) : const Icon(Icons.person_add),
                    label: Text('Create account', style: ts.labelLarge?.copyWith(color: cs.onPrimary)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(onPressed: ()=> context.go('/auth/login'), child: const Text('Already have an account? Sign in')),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRegister() async {
    if(!_formKey.currentState!.validate()) return;
    setState(()=> _loading = true);
    try {
      context.read<AppState>().register(
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        password: _passwordCtrl.text,
        role: _role,
      );
      if(!mounted) return;
      context.go('/org/company/select');
    } catch (e) {
      debugPrint('Register error: $e');
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
    } finally {
      if(mounted) setState(()=> _loading = false);
    }
  }
}
