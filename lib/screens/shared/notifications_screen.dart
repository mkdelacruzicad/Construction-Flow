import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10, (i)=> {'title':'Notification ${i+1}','time':'Just now'});
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i){ final it = items[i]; return ListTile(leading: const Icon(Icons.notifications), title: Text(it['title'] as String), subtitle: Text(it['time'] as String)); },
      ),
    );
  }
}
