import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:siteflow/screens/dev/role_selection_screen.dart';
import 'package:siteflow/screens/procurement/procurement_dashboard.dart';
import 'package:siteflow/screens/procurement/create_rfq_screen.dart';
import 'package:siteflow/screens/supplier/supplier_dashboard.dart';
import 'package:siteflow/screens/supplier/marketplace_screen.dart';
import 'package:siteflow/screens/supplier/rfq_details_screen.dart';
import 'package:siteflow/screens/supplier/quote_submission_screen.dart';
import 'package:siteflow/screens/warehouse/warehouse_dashboard.dart';
import 'package:siteflow/screens/warehouse/receive_goods_screen.dart';
import 'package:siteflow/screens/warehouse/inventory_screen.dart';
import 'package:siteflow/screens/warehouse/transfer_stock_screen.dart';
import 'package:siteflow/screens/warehouse/cycle_count_screen.dart';
import 'package:siteflow/screens/warehouse/dispatch_screen.dart';
import 'package:siteflow/screens/warehouse/putaway_screen.dart';
import 'package:siteflow/screens/account/account_info_screen.dart';
import 'package:siteflow/screens/auth/splash_screen.dart';
import 'package:siteflow/screens/auth/auth_login_screen.dart';
import 'package:siteflow/screens/auth/register_screen.dart';
import 'package:siteflow/screens/auth/verify_otp_screen.dart';
import 'package:siteflow/screens/auth/forgot_password_screen.dart';
import 'package:siteflow/screens/auth/reset_password_screen.dart';
import 'package:siteflow/screens/org/select_company_screen.dart';
import 'package:siteflow/screens/org/create_company_screen.dart';
import 'package:siteflow/screens/org/join_company_screen.dart';
import 'package:siteflow/screens/org/pending_approval_screen.dart';
import 'package:siteflow/screens/org/select_project_screen.dart';
import 'package:siteflow/screens/org/create_project_screen.dart';
import 'package:siteflow/screens/shells/procurement_shell.dart';
import 'package:siteflow/screens/shells/supplier_shell.dart';
import 'package:siteflow/screens/shells/warehouse_shell.dart';
import 'package:siteflow/screens/procurement/rfqs/rfq_list_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/rfq_details_procurement_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/invite_vendors_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/invite_summary_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/invite_success_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/rfq_submissions_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/submission_details_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/compare_vendors_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/award_decision_screen.dart';
import 'package:siteflow/screens/procurement/rfqs/rfq_decision_board_screen.dart';
import 'package:siteflow/screens/procurement/pos/po_list_screen.dart';
import 'package:siteflow/screens/procurement/pos/po_details_screen.dart';
import 'package:siteflow/screens/procurement/pos/create_po_from_award_screen.dart';
import 'package:siteflow/screens/procurement/vendors/vendor_list_screen.dart';
import 'package:siteflow/screens/procurement/vendors/vendor_scorecard_screen.dart';
import 'package:siteflow/screens/supplier/opportunities/opportunities_screen.dart';
import 'package:siteflow/screens/supplier/submissions/supplier_submissions_screen.dart';
import 'package:siteflow/screens/supplier/catalog/catalog_list_screen.dart';
import 'package:siteflow/screens/supplier/catalog/add_edit_catalog_item_screen.dart';
import 'package:siteflow/screens/supplier/profile/supplier_profile_setup_screen.dart';
import 'package:siteflow/screens/supplier/profile/verification_status_screen.dart';
import 'package:siteflow/screens/supplier/profile/supplier_performance_screen.dart';
import 'package:siteflow/screens/warehouse/select_po_to_receive_screen.dart';
import 'package:siteflow/screens/warehouse/receive_against_po_screen.dart';
import 'package:siteflow/screens/warehouse/grn_summary_screen.dart';
import 'package:siteflow/screens/warehouse/stock_movement_history_screen.dart';
import 'package:siteflow/screens/warehouse/manual_adjustment_screen.dart';
import 'package:siteflow/screens/warehouse/locations_and_bins_screen.dart';
import 'package:siteflow/screens/warehouse/putaway_task_detail_screen.dart';
import 'package:siteflow/screens/shared/notifications_screen.dart';
import 'package:siteflow/screens/shared/global_search_screen.dart';
import 'package:siteflow/screens/shared/team_management_screen.dart';
import 'package:siteflow/screens/shared/settings_screen.dart';
import 'package:siteflow/screens/shared/help_support_screen.dart';

import 'package:siteflow/services/app_state.dart';
import 'package:siteflow/screens/auth/unauthorized_screen.dart';

class AppRouter {
  static GoRouter createRouter(AppState appState) {
    return GoRouter(
      initialLocation: '/auth/splash',
      refreshListenable: appState,
      redirect: (context, state) {
        final loc = state.uri.path;
        // Normalize legacy dashboard entries to shell dashboards
        if (loc == '/procurement') return '/procurement-shell/dashboard';
        if (loc == '/supplier') return '/supplier-shell/dashboard';
        if (loc == '/warehouse') return '/warehouse-shell/dashboard';

        final isAuthRoute = loc.startsWith('/auth');
        final isOrgRoute = loc.startsWith('/org');
        final isDevRoute = loc.startsWith('/dev');
        final isUnauthorized = loc == '/unauthorized';

        // Auth protection
        if (!appState.isLoggedIn && !isAuthRoute && !isDevRoute) {
          return '/auth/login';
        }

        // Organization context enforcement
        if (appState.isLoggedIn) {
          if (appState.companyId == null && !loc.startsWith('/org/company') && !isAuthRoute) {
            return '/org/company/select';
          }
          if (appState.companyId != null && appState.projectId == null && !loc.startsWith('/org/project') && !isAuthRoute) {
            return '/org/project/select';
          }
        }

        // Role-based shell routing after org context is ready
        if (appState.isLoggedIn && appState.companyId != null && appState.projectId != null) {
          final role = appState.role ?? 'procurement';
          final dest = switch (role) {
            'procurement' => '/procurement-shell/dashboard',
            'supplier' => '/supplier-shell/dashboard',
            'warehouse' => '/warehouse-shell/dashboard',
            _ => '/procurement-shell/dashboard',
          };

          // If trying to access auth or org while fully set up, go to role dashboard
          if (isAuthRoute || isOrgRoute || loc == '/' || loc == '/dev/role-selection') {
            return dest;
          }

          // Strict role-based shell access: block other shells with Unauthorized screen
          final onProcShell = loc.startsWith('/procurement-shell');
          final onSuppShell = loc.startsWith('/supplier-shell');
          final onWhShell = loc.startsWith('/warehouse-shell');
          final accessingOtherShell =
              (role == 'procurement' && (onSuppShell || onWhShell)) ||
              (role == 'supplier' && (onProcShell || onWhShell)) ||
              (role == 'warehouse' && (onProcShell || onSuppShell));

          if (accessingOtherShell && !isUnauthorized) {
            return '/unauthorized';
          }
        }

        // All good, no redirect
        return null;
      },
      routes: [
        // Root redirect to splash
        GoRoute(path: '/', redirect: (_, __) => '/auth/splash'),

        // Auth Routes
        GoRoute(path: '/auth/splash', builder: (context, state) => const SplashScreen()),
        GoRoute(path: '/auth/login', builder: (context, state) => const AuthLoginScreen()),
        GoRoute(path: '/auth/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(path: '/auth/verify-otp', builder: (context, state) => VerifyOtpScreen(nextPath: state.uri.queryParameters['next'])),
        GoRoute(path: '/auth/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
        GoRoute(path: '/auth/reset-password', builder: (context, state) => const ResetPasswordScreen()),

        // Unauthorized
        GoRoute(path: '/unauthorized', builder: (context, state) => const UnauthorizedScreen()),

        // Dev tools
        if (!kReleaseMode)
          GoRoute(path: '/dev/role-selection', builder: (context, state) => const RoleSelectionScreen()),

        // Account
        GoRoute(path: '/account', builder: (context, state) => const AccountInfoScreen()),

        // Org selection routes
        GoRoute(path: '/org/company/select', builder: (context, state) => const SelectCompanyScreen()),
        GoRoute(path: '/org/company/create', builder: (context, state) => const CreateCompanyScreen()),
        GoRoute(path: '/org/company/join', builder: (context, state) => const JoinCompanyScreen()),
        GoRoute(path: '/org/company/pending', builder: (context, state) => const PendingApprovalScreen()),
        GoRoute(path: '/org/project/select', builder: (context, state) => const SelectProjectScreen()),
        GoRoute(path: '/org/project/create', builder: (context, state) => const CreateProjectScreen()),

        // Procurement Shell with nested routes
        ShellRoute(
          builder: (context, state, child) => ProcurementShell(child: child),
          routes: [
            GoRoute(path: '/procurement-shell/dashboard', builder: (context, state) => const ProcurementDashboard()),
            GoRoute(path: '/procurement-shell/rfqs', builder: (context, state) => const RFQListScreen()),
            GoRoute(path: '/procurement-shell/rfq/create', builder: (context, state) => const CreateRFQScreen()),
            GoRoute(path: '/procurement-shell/rfqs/:id', builder: (context, state) => RFQDetailsProcurementScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/decision-board', builder: (context, state) => RFQDecisionBoardScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/invite', builder: (context, state) => InviteVendorsScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/invite/summary', builder: (context, state) => InviteSummaryScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/invite/success', builder: (context, state) => InviteSuccessScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/submissions', builder: (context, state) => RFQSubmissionsScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/submissions/:vendorId', builder: (context, state) => SubmissionDetailsScreen(rfqId: state.pathParameters['id']!, vendorId: state.pathParameters['vendorId']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/compare', builder: (context, state) => CompareVendorsScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/award', builder: (context, state) => AwardDecisionScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/rfqs/:id/create-po', builder: (context, state) => CreatePOFromAwardScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/pos', builder: (context, state) => const POListScreen()),
            GoRoute(path: '/procurement-shell/pos/:id', builder: (context, state) => PODetailsScreen(poId: state.pathParameters['id']!)),
            GoRoute(path: '/procurement-shell/vendors', builder: (context, state) => const VendorListScreen()),
            GoRoute(path: '/procurement-shell/vendors/:vendorId/scorecard', builder: (context, state) => VendorScorecardScreen(vendorId: state.pathParameters['vendorId']!)),
          ],
        ),

        // Supplier Shell with nested routes
        ShellRoute(
          builder: (context, state, child) => SupplierShell(child: child),
          routes: [
            GoRoute(path: '/supplier-shell/dashboard', builder: (context, state) => const SupplierDashboard()),
            GoRoute(path: '/supplier-shell/opportunities', builder: (context, state) => const OpportunitiesScreen()),
            GoRoute(path: '/supplier-shell/submissions', builder: (context, state) => const SupplierSubmissionsScreen()),
            GoRoute(path: '/supplier-shell/catalog', builder: (context, state) => const CatalogListScreen()),
            GoRoute(path: '/supplier-shell/catalog/new', builder: (context, state) => const AddEditCatalogItemScreen()),
            GoRoute(path: '/supplier-shell/catalog/:id', builder: (context, state) => AddEditCatalogItemScreen(itemId: state.pathParameters['id']!)),
            GoRoute(path: '/supplier-shell/marketplace', builder: (context, state) => const MarketplaceScreen()),
            GoRoute(path: '/supplier-shell/rfq/:id', builder: (context, state) => RFQDetailsScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/supplier-shell/rfq/:id/quote', builder: (context, state) => QuoteSubmissionScreen(rfqId: state.pathParameters['id']!)),
            GoRoute(path: '/supplier-shell/profile/setup', builder: (context, state) => const SupplierProfileSetupScreen()),
            GoRoute(path: '/supplier-shell/profile/verification', builder: (context, state) => const VerificationStatusScreen()),
            GoRoute(path: '/supplier-shell/profile/performance', builder: (context, state) => const SupplierPerformanceScreen()),
          ],
        ),

        // Warehouse Shell with nested routes
        ShellRoute(
          builder: (context, state, child) => WarehouseShell(child: child),
          routes: [
            GoRoute(path: '/warehouse-shell/dashboard', builder: (context, state) => const WarehouseDashboard()),
            GoRoute(path: '/warehouse-shell/receiving', builder: (context, state) => const SelectPOToReceiveScreen()),
            GoRoute(path: '/warehouse-shell/inventory', builder: (context, state) => const WarehouseInventoryScreen()),
            GoRoute(path: '/warehouse-shell/dispatch', builder: (context, state) => const WarehouseDispatchScreen()),
            GoRoute(path: '/warehouse-shell/locations', builder: (context, state) => const LocationsAndBinsScreen()),
            GoRoute(path: '/warehouse-shell/adjustments', builder: (context, state) => const ManualAdjustmentScreen()),
            GoRoute(path: '/warehouse-shell/transfer', builder: (context, state) => const WarehouseTransferScreen()),
            GoRoute(path: '/warehouse-shell/cycle-count', builder: (context, state) => const WarehouseCycleCountScreen()),
            GoRoute(path: '/warehouse-shell/putaway', builder: (context, state) => const WarehousePutawayScreen()),
            GoRoute(path: '/warehouse-shell/receiving/:poId', builder: (context, state) => ReceiveAgainstPOScreen(poId: state.pathParameters['poId']!)),
            GoRoute(path: '/warehouse-shell/receiving/:poId/grn', builder: (context, state) => GRNSummaryScreen(poId: state.pathParameters['poId']!)),
            GoRoute(path: '/warehouse-shell/movements', builder: (context, state) => const StockMovementHistoryScreen()),
            GoRoute(path: '/warehouse-shell/putaway/task/:id', builder: (context, state) => PutawayTaskDetailScreen(taskId: state.pathParameters['id']!)),
          ],
        ),

        // Shared / Global
        GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
        GoRoute(path: '/search', builder: (context, state) => const GlobalSearchScreen()),
        GoRoute(path: '/team', builder: (context, state) => const TeamManagementScreen()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        GoRoute(path: '/help', builder: (context, state) => const HelpSupportScreen()),
      ],
    );
  }
}

class AppRoutes {
  static const String home = '/';
}
