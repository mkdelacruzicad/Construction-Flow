import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../models/data_models.dart';
import '../../services/mock_data_service.dart';

class LoginScreen extends StatefulWidget {
  final String roleParam;
  const LoginScreen({super.key, required this.roleParam});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  UserRole? get _role => _parseRole(widget.roleParam);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = context.textStyles;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in', style: ts.titleLarge),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _RoleBadge(role: _role),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome back',
                    style: ts.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Sign in to continue to your dashboard', style: ts.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Work email',
                            prefixIcon: Icon(Icons.mail),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.username, AutofillHints.email],
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email is required';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: cs.onSurfaceVariant),
                            ),
                          ),
                          obscureText: _obscure,
                          validator: (v) => (v == null || v.isEmpty) ? 'Password is required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _loading ? null : _onSignIn,
                      icon: _loading
                          ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: cs.onPrimary))
                          : const Icon(Icons.login),
                      label: Text('Sign in', style: ts.labelLarge?.copyWith(color: cs.onPrimary)),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'Tip: use password "password123" with a mock email for the role.',
                    style: ts.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSignIn() async {
    final role = _role;
    if (role == null) {
      _showError('Invalid role. Go back and select a role again.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final ok = context.read<MockDataService>().loginWithEmail(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
            role: role,
          );
      if (!ok) {
        _showError('Incorrect email or password for this role.');
        return;
      }

      switch (role) {
        case UserRole.procurement:
          if (!mounted) return; context.go('/procurement');
          break;
        case UserRole.supplier:
          if (!mounted) return; context.go('/supplier');
          break;
        case UserRole.warehouse:
          if (!mounted) return; context.go('/warehouse');
          break;
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _RoleBadge extends StatelessWidget {
  final UserRole? role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = context.textStyles;
    final label = switch (role) {
      UserRole.procurement => 'Procurement Officer',
      UserRole.supplier => 'Supplier',
      UserRole.warehouse => 'Warehouse Manager',
      null => 'Unknown Role'
    };
    final icon = switch (role) {
      UserRole.procurement => Icons.assignment_ind,
      UserRole.supplier => Icons.storefront,
      UserRole.warehouse => Icons.warehouse,
      null => Icons.help_outline,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Text(label, style: ts.labelLarge?.copyWith(color: cs.primary)),
        ],
      ),
    );
  }
}

UserRole? _parseRole(String raw) {
  switch (raw.toLowerCase()) {
    case 'procurement':
      return UserRole.procurement;
    case 'supplier':
      return UserRole.supplier;
    case 'warehouse':
      return UserRole.warehouse;
  }
  return null;
}
