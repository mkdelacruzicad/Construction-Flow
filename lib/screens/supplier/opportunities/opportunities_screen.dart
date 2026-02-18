import 'package:flutter/material.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opportunities'), bottom: TabBar(controller: _tab, isScrollable: true, tabs: const [
        Tab(text: 'Invited RFQs'), Tab(text: 'Public RFQs'), Tab(text: 'Closing soon'), Tab(text: 'History'),
      ])),
      body: TabBarView(controller: _tab, children: const [
        _List(kind: 'Invited'), _List(kind: 'Public'), _List(kind: 'Closing'), _List(kind: 'History'),
      ]),
    );
  }
}

class _List extends StatelessWidget {
  final String kind;
  const _List({required this.kind});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10, (i)=> {'id':'R${i+1}','title': '$kind RFQ ${i+1}','due':'2025-06-${10+i}'});
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i){
        final it = items[i];
        return Card(child: ListTile(
          title: Text(it['title'] as String),
          subtitle: Text('Due ${it['due']}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: (){},
        ));
      },
    );
  }
}
