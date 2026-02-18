import 'package:flutter/material.dart';
import 'package:siteflow/screens/procurement/procurement_dashboard.dart';
import 'package:siteflow/screens/procurement/rfqs/rfq_list_screen.dart';
import 'package:siteflow/screens/procurement/vendors/vendor_list_screen.dart';
import 'package:siteflow/screens/procurement/pos/po_list_screen.dart';

class ProcurementShell extends StatefulWidget {
  final Widget? child; // for ShellRoute usage if needed
  const ProcurementShell({super.key, this.child});

  @override
  State<ProcurementShell> createState() => _ProcurementShellState();
}

class _ProcurementShellState extends State<ProcurementShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const ProcurementDashboard(),
      const RFQListScreen(),
      const VendorListScreen(),
      const POListScreen(),
    ];
    final titles = ['Dashboard', 'RFQs', 'Vendors', 'Purchase Orders'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description), label: 'RFQs'),
          NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group), label: 'Vendors'),
          NavigationDestination(icon: Icon(Icons.assignment_turned_in_outlined), selectedIcon: Icon(Icons.assignment_turned_in), label: 'POs'),
        ],
      ),
    );
  }
}
