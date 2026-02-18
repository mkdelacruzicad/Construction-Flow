import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InviteVendorsScreen extends StatefulWidget {
  final String rfqId;
  const InviteVendorsScreen({super.key, required this.rfqId});

  @override
  State<InviteVendorsScreen> createState() => _InviteVendorsScreenState();
}

class _InviteVendorsScreenState extends State<InviteVendorsScreen> {
  final _vendors = List.generate(20, (i) => {'id': 'v$i', 'name': 'Vendor ${i+1}', 'category': ['Concrete','Steel','Electrical'][i%3]});
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Invite vendors', style: ts.titleLarge)),
      body: Column(children:[
        Padding(padding: const EdgeInsets.all(12), child: Row(children:[
          Expanded(child: TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search vendors'))),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.filter_list), label: const Text('Filters')),
        ])),
        Expanded(child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: _vendors.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i){
            final v = _vendors[i];
            final id = v['id'] as String;
            final selected = _selected.contains(id);
            return Card(child: CheckboxListTile(
              value: selected,
              onChanged: (val){ setState((){ if(val==true){_selected.add(id);} else {_selected.remove(id);} }); },
              title: Text(v['name'] as String),
              subtitle: Text(v['category'] as String),
            ));
          },
        )),
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton(
          onPressed: _selected.isEmpty? null : ()=> context.push('/procurement-shell/rfqs/${widget.rfqId}/invite/summary', extra: _selected.toList()),
          child: Text('Next (${_selected.length})'),
        ),
      ),
    );
  }
}
