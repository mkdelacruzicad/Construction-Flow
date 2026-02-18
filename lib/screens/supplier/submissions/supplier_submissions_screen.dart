import 'package:flutter/material.dart';

class SupplierSubmissionsScreen extends StatefulWidget {
  const SupplierSubmissionsScreen({super.key});

  @override
  State<SupplierSubmissionsScreen> createState() => _SupplierSubmissionsScreenState();
}

class _SupplierSubmissionsScreenState extends State<SupplierSubmissionsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My submissions'), bottom: TabBar(controller: _tab, isScrollable: true, tabs: const [
        Tab(text: 'Draft'), Tab(text: 'Submitted'), Tab(text: 'Awarded'), Tab(text: 'Rejected'),
      ])),
      body: TabBarView(controller: _tab, children: const [
        _List(status: 'Draft'), _List(status: 'Submitted'), _List(status: 'Awarded'), _List(status: 'Rejected'),
      ]),
    );
  }
}

class _List extends StatelessWidget {
  final String status;
  const _List({required this.status});
  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i)=> {'id':'R${i+1}','title':'RFQ ${i+1}','status': status});
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i){
        final it = items[i];
        return Card(child: ListTile(
          title: Text(it['title'] as String),
          subtitle: Text(it['status'] as String),
          trailing: const Icon(Icons.chevron_right),
          onTap: (){},
        ));
      },
    );
  }
}
