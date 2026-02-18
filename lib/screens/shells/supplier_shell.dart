import 'package:flutter/material.dart';
import 'package:siteflow/screens/supplier/supplier_dashboard.dart';
import 'package:siteflow/screens/supplier/opportunities/opportunities_screen.dart';
import 'package:siteflow/screens/supplier/submissions/supplier_submissions_screen.dart';
import 'package:siteflow/screens/supplier/catalog/catalog_list_screen.dart';

class SupplierShell extends StatefulWidget {
  const SupplierShell({super.key});

  @override
  State<SupplierShell> createState() => _SupplierShellState();
}

class _SupplierShellState extends State<SupplierShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      SupplierDashboard(),
      OpportunitiesScreen(),
      SupplierSubmissionsScreen(),
      CatalogListScreen(),
    ];
    final titles = ['Dashboard', 'Opportunities', 'Submissions', 'Catalog'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.cases_outlined), selectedIcon: Icon(Icons.cases_rounded), label: 'Opportunities'),
          NavigationDestination(icon: Icon(Icons.inbox_outlined), selectedIcon: Icon(Icons.inbox), label: 'Submissions'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Catalog'),
        ],
      ),
    );
  }
}
