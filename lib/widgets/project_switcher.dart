import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Lightweight project switcher button to place in dashboards' AppBars.
class ProjectSwitcher extends StatelessWidget {
  final String? currentProjectName;
  const ProjectSwitcher({super.key, this.currentProjectName});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => context.push('/org/project/select'),
      icon: const Icon(Icons.swap_horiz),
      label: Text(currentProjectName ?? 'Switch project'),
    );
  }
}
