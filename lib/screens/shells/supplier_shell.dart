import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siteflow/screens/supplier/supplier_dashboard.dart';
import 'package:siteflow/screens/supplier/opportunities/opportunities_screen.dart';
import 'package:siteflow/screens/supplier/submissions/supplier_submissions_screen.dart';
import 'package:siteflow/screens/supplier/catalog/catalog_list_screen.dart';
import 'package:siteflow/widgets/project_switcher.dart';
import 'package:siteflow/screens/supplier/marketplace_screen.dart';
import 'package:siteflow/screens/supplier/rfq_details_screen.dart';
import 'package:siteflow/screens/supplier/quote_submission_screen.dart';
import 'package:siteflow/screens/supplier/catalog/add_edit_catalog_item_screen.dart';

class SupplierShell extends StatefulWidget {
  final Widget? child;
  const SupplierShell({super.key, this.child});

  @override
  State<SupplierShell> createState() => _SupplierShellState();
}

class _SupplierShellState extends State<SupplierShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    int currentIndex = _indexForChild(widget.child);
    final titles = ['Dashboard', 'Opportunities', 'Submissions', 'Catalog'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[currentIndex]), actions: const [ProjectSwitcher()]),
      body: widget.child ?? const SupplierDashboard(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _onTapNav(i, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.cases_outlined), selectedIcon: Icon(Icons.cases_rounded), label: 'Opportunities'),
          NavigationDestination(icon: Icon(Icons.inbox_outlined), selectedIcon: Icon(Icons.inbox), label: 'Submissions'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Catalog'),
        ],
      ),
    );
  }

  int _indexForChild(Widget? child) {
    final c = child;
    if (c is OpportunitiesScreen || c is MarketplaceScreen || c is RFQDetailsScreen || c is QuoteSubmissionScreen) return 1;
    if (c is SupplierSubmissionsScreen) return 2;
    if (c is CatalogListScreen || c is AddEditCatalogItemScreen) return 3;
    return 0;
  }

  void _onTapNav(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/supplier-shell/dashboard');
        break;
      case 1:
        context.go('/supplier-shell/opportunities');
        break;
      case 2:
        context.go('/supplier-shell/submissions');
        break;
      case 3:
        context.go('/supplier-shell/catalog');
        break;
    }
  }
}
