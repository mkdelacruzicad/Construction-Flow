import 'package:flutter/material.dart';
import 'package:siteflow/screens/warehouse/warehouse_dashboard.dart';
import 'package:siteflow/screens/warehouse/select_po_to_receive_screen.dart';
import 'package:siteflow/screens/warehouse/inventory_screen.dart';
import 'package:siteflow/screens/warehouse/dispatch_screen.dart';

class WarehouseShell extends StatefulWidget {
  const WarehouseShell({super.key});

  @override
  State<WarehouseShell> createState() => _WarehouseShellState();
}

class _WarehouseShellState extends State<WarehouseShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      WarehouseDashboard(),
      SelectPOToReceiveScreen(),
      WarehouseInventoryScreen(),
      WarehouseDispatchScreen(),
    ];
    final titles = ['Dashboard', 'Receiving', 'Inventory', 'Dispatch'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.move_to_inbox_outlined), selectedIcon: Icon(Icons.move_to_inbox), label: 'Receiving'),
          NavigationDestination(icon: Icon(Icons.warehouse_outlined), selectedIcon: Icon(Icons.warehouse), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.local_shipping_outlined), selectedIcon: Icon(Icons.local_shipping), label: 'Dispatch'),
        ],
      ),
    );
  }
}
