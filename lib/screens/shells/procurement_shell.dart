import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siteflow/screens/procurement/procurement_dashboard.dart';
import 'package:siteflow/screens/procurement/rfqs/rfq_list_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/rfq_details_procurement_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/invite_vendors_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/invite_summary_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/invite_success_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/rfq_submissions_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/submission_details_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/compare_vendors_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/award_decision_screen.dart';
import 'package:siteflow/screens/procurement/pos/po_details_screen.dart';
import 'package:siteflow/screens/procurement/pos/create_po_from_award_screen.dart';
import 'package:siteflow/screens/procurement/vendors/vendor_list_screen.dart';
import 'package:siteflow/screens/procurement/pos/po_list_screen.dart';
import 'package:siteflow/widgets/project_switcher.dart';

class ProcurementShell extends StatefulWidget {
  final Widget? child; // Used by ShellRoute to render nested pages
  const ProcurementShell({super.key, this.child});

  @override
  State<ProcurementShell> createState() => _ProcurementShellState();
}

class _ProcurementShellState extends State<ProcurementShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    int currentIndex = _indexForChild(widget.child);
    final titles = ['Dashboard', 'RFQs', 'Vendors', 'Purchase Orders'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[currentIndex]), actions: const [ProjectSwitcher()]),
      body: widget.child ?? const ProcurementDashboard(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _onTapNav(i, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description), label: 'RFQs'),
          NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group), label: 'Vendors'),
          NavigationDestination(icon: Icon(Icons.assignment_turned_in_outlined), selectedIcon: Icon(Icons.assignment_turned_in), label: 'POs'),
        ],
      ),
    );
  }

  int _indexForChild(Widget? child) {
    final c = child;
    if (c is RFQListScreen || c is RFQDetailsProcurementScreen || c is InviteVendorsScreen || c is InviteSummaryScreen || c is InviteSuccessScreen || c is RFQSubmissionsScreen || c is SubmissionDetailsScreen || c is CompareVendorsScreen || c is AwardDecisionScreen || c is CreatePOFromAwardScreen) return 1;
    if (c is VendorListScreen) return 2;
    if (c is POListScreen || c is PODetailsScreen) return 3;
    return 0;
  }

  void _onTapNav(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/procurement-shell/dashboard');
        break;
      case 1:
        context.go('/procurement-shell/rfqs');
        break;
      case 2:
        context.go('/procurement-shell/vendors');
        break;
      case 3:
        context.go('/procurement-shell/pos');
        break;
    }
  }
}
