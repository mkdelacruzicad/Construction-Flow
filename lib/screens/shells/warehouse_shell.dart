import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siteflow/screens/warehouse/warehouse_dashboard.dart';
import 'package:siteflow/screens/warehouse/select_po_to_receive_screen.dart';
import 'package:siteflow/screens/warehouse/inventory_screen.dart';
import 'package:siteflow/screens/warehouse/dispatch_screen.dart';
import 'package:siteflow/widgets/project_switcher.dart';
import 'package:siteflow/screens/warehouse/receive_against_po_screen.dart';
import 'package:siteflow/screens/warehouse/grn_summary_screen.dart';
import 'package:siteflow/screens/warehouse/stock_movement_history_screen.dart';
import 'package:siteflow/screens/warehouse/locations_and_bins_screen.dart';
import 'package:siteflow/screens/warehouse/manual_adjustment_screen.dart';
import 'package:siteflow/screens/warehouse/putaway_task_detail_screen.dart';

class WarehouseShell extends StatefulWidget {
  final Widget? child;
  const WarehouseShell({super.key, this.child});

  @override
  State<WarehouseShell> createState() => _WarehouseShellState();
}

class _WarehouseShellState extends State<WarehouseShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    int currentIndex = _indexForChild(widget.child);
    final titles = ['Dashboard', 'Receiving', 'Inventory', 'Dispatch'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[currentIndex]), actions: const [ProjectSwitcher()]),
      body: widget.child ?? const WarehouseDashboard(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _onTapNav(i, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.move_to_inbox_outlined), selectedIcon: Icon(Icons.move_to_inbox), label: 'Receiving'),
          NavigationDestination(icon: Icon(Icons.warehouse_outlined), selectedIcon: Icon(Icons.warehouse), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.local_shipping_outlined), selectedIcon: Icon(Icons.local_shipping), label: 'Dispatch'),
        ],
      ),
    );
  }

  int _indexForChild(Widget? child) {
    final c = child;
    if (c is SelectPOToReceiveScreen || c is ReceiveAgainstPOScreen || c is GRNSummaryScreen) return 1;
    if (c is WarehouseInventoryScreen || c is LocationsAndBinsScreen || c is ManualAdjustmentScreen || c is PutawayTaskDetailScreen) return 2;
    if (c is WarehouseDispatchScreen || c is StockMovementHistoryScreen) return 3;
    return 0;
  }

  void _onTapNav(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/warehouse-shell/dashboard');
        break;
      case 1:
        context.go('/warehouse-shell/receiving');
        break;
      case 2:
        context.go('/warehouse-shell/inventory');
        break;
      case 3:
        context.go('/warehouse-shell/dispatch');
        break;
    }
  }
}
