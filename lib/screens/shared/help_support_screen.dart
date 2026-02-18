import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(padding: const EdgeInsets.all(12), children: const [
        _Tile(icon: Icons.help_outline, title: 'FAQ'),
        _Tile(icon: Icons.email_outlined, title: 'Contact support'),
        _Tile(icon: Icons.description_outlined, title: 'Documentation'),
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
