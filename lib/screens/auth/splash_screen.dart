import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:siteflow/services/app_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decideNext());
  }

  Future<void> _decideNext() async {
    final app = context.read<AppState>();
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!app.isLoggedIn) {
      if (!mounted) return; context.go('/auth/login');
      return;
    }
    if (app.companyId == null) {
      if (!mounted) return; context.go('/org/company/select');
      return;
    }
    if (app.projectId == null) {
      if (!mounted) return; context.go('/org/project/select');
      return;
    }
    final role = app.role ?? 'procurement';
    final dest = switch (role) {
      'procurement' => '/procurement-shell/dashboard',
      'supplier' => '/supplier-shell/dashboard',
      'warehouse' => '/warehouse-shell/dashboard',
      _ => '/procurement-shell/dashboard',
    };
    if (!mounted) return; context.go(dest);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.engineering, size: 64, color: cs.primary),
            const SizedBox(height: 12),
            Text('Construction-Flow', style: ts.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(width: 160, child: LinearProgressIndicator(backgroundColor: cs.primaryContainer)),
          ],
        ),
      ),
    );
  }
}
