import 'package:flutter/material.dart';

class CompareVendorsScreen extends StatelessWidget {
  final String rfqId;
  const CompareVendorsScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    final headers = ['Vendor','Price','Lead time','Compliance'];
    final rows = List.generate(4, (r)=> ['Vendor ${r+1}','\$${(r+1)*10000}','${10+r} days', r%2==0? 'Yes':'Partial']);
    return Scaffold(
      appBar: AppBar(title: const Text('Compare vendors')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(columns: headers.map((h)=> DataColumn(label: Text(h))).toList(), rows: rows.map((r)=> DataRow(cells: r.map((c)=> DataCell(Text(c))).toList())).toList()),
      ),
    );
  }
}
