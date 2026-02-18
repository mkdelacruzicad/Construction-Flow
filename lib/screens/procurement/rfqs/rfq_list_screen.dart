import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RFQListScreen extends StatefulWidget {
  const RFQListScreen({super.key});

  @override
  State<RFQListScreen> createState() => _RFQListScreenState();
}

class _RFQListScreenState extends State<RFQListScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('RFQs', style: ts.titleLarge),
        bottom: TabBar(controller: _tab, isScrollable: true, tabs: const [
          Tab(text: 'Draft'), Tab(text: 'Published'), Tab(text: 'Closed'), Tab(text: 'Awarded'),
        ]),
      ),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: Row(children:[
          Expanded(child: TextField(controller: _searchCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search or filter'))),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.filter_list), label: const Text('Filters')),
        ])),
        Expanded(
          child: TabBarView(controller: _tab, children: List.generate(4, (tabIdx) => _RFQList(tab: tabIdx))),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=> context.push('/procurement/rfq/create'), icon: const Icon(Icons.add), label: const Text('New RFQ')),
    );
  }
}

class _RFQList extends StatelessWidget {
  final int tab;
  const _RFQList({required this.tab});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => {'id': 'R${tab+1}00$i', 'title': 'RFQ ${i+1}', 'due': '2025-06-1${i}', 'status': ['Draft','Published','Closed','Awarded'][tab]});
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final it = items[i];
        return Card(
          child: ListTile(
            title: Text(it['title'] as String),
            subtitle: Text('Due ${it['due']}'),
            trailing: Text(it['status'] as String),
            onTap: () => context.push('/procurement/rfqs/${it['id']}'),
          ),
        );
      },
    );
  }
}
