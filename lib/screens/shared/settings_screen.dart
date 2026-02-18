import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(12), children: const [
        _Tile(icon: Icons.palette, title: 'Appearance'),
        _Tile(icon: Icons.notifications, title: 'Notifications'),
        _Tile(icon: Icons.security, title: 'Security'),
        _Tile(icon: Icons.info_outline, title: 'About'),
      ]),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon; final String title;
  const _Tile({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right)));
}
