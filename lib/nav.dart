import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siteflow/screens/role_selection_screen.dart';
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
import 'package:siteflow/screens/auth/login_screen.dart';
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
import 'package:siteflow/screens/procurement/pos/po_list_screen.dart';
import 'package:siteflow/screens/procurement/pos/po_details_screen.dart';
import 'package:siteflow/screens/procurement/pos/create_po_from_award_screen.dart';
import 'package:siteflow/screens/supplier/opportunities/opportunities_screen.dart';
import 'package:siteflow/screens/supplier/submissions/supplier_submissions_screen.dart';
import 'package:siteflow/screens/supplier/catalog/catalog_list_screen.dart';
import 'package:siteflow/screens/supplier/catalog/add_edit_catalog_item_screen.dart';
import 'package:siteflow/screens/supplier/profile/supplier_profile_setup_screen.dart';
import 'package:siteflow/screens/supplier/profile/verification_status_screen.dart';
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

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth/splash',
    routes: [
      // Auth Routes
      GoRoute(path: '/auth/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/auth/login', builder: (context, state) => const AuthLoginScreen()),
      GoRoute(path: '/auth/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/auth/verify-otp', builder: (context, state) => const VerifyOtpScreen()),
      GoRoute(path: '/auth/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: '/auth/reset-password', builder: (context, state) => const ResetPasswordScreen()),

      // Keep dev/demo role selection route at root
      GoRoute(path: AppRoutes.home, builder: (context, state) => const RoleSelectionScreen()),
      GoRoute(path: '/account', builder: (context, state) => const AccountInfoScreen()),

      // Legacy login (kept intact)
      GoRoute(path: '/login', builder: (context, state) { final roleParam = state.uri.queryParameters['role'] ?? ''; return LoginScreen(roleParam: roleParam); }),

      // Org selection routes
      GoRoute(path: '/org/company/select', builder: (context, state) => const SelectCompanyScreen()),
      GoRoute(path: '/org/company/create', builder: (context, state) => const CreateCompanyScreen()),
      GoRoute(path: '/org/company/join', builder: (context, state) => const JoinCompanyScreen()),
      GoRoute(path: '/org/company/pending', builder: (context, state) => const PendingApprovalScreen()),
      GoRoute(path: '/org/project/select', builder: (context, state) => const SelectProjectScreen()),
      GoRoute(path: '/org/project/create', builder: (context, state) => const CreateProjectScreen()),

      // Procurement Routes (existing)
      GoRoute(path: '/procurement', builder: (context, state) => const ProcurementDashboard(), routes: [
        GoRoute(path: 'rfq/create', builder: (context, state) => const CreateRFQScreen()),
      ]),

      // Procurement Shell
      GoRoute(path: '/procurement-shell', builder: (context, state) => const ProcurementShell()),
      GoRoute(path: '/procurement-shell/dashboard', builder: (context, state) => const ProcurementShell()),

      // Procurement module completion
      GoRoute(path: '/procurement/rfqs', builder: (context, state) => const RFQListScreen()),
      GoRoute(path: '/procurement/rfqs/:id', builder: (context, state) => RFQDetailsProcurementScreen(rfqId: state.pathParameters['id']!)),
      GoRoute(path: '/procurement/rfqs/:id/invite', builder: (context, state) => InviteVendorsScreen(rfqId: state.pathParameters['id']!)),
      GoRoute(path: '/procurement/rfqs/:id/invite/summary', builder: (context, state) => InviteSummaryScreen(rfqId: state.pathParameters['id']!)),
      GoRoute(path: '/procurement/rfqs/:id/invite/success', builder: (context, state) => InviteSuccessScreen(rfqId: state.pathParameters['id']!)),
      GoRoute(path: '/procurement/rfqs/:id/submissions', builder: (context, state) => RFQSubmissionsScreen(rfqId: state.pathParameters['id']!)),
      GoRoute(path: '/procurement/rfqs/:id/submissions/:vendorId', builder: (context, state) => SubmissionDetailsScreen(rfqId: state.pathParameters['id']!, vendorId: state.pathParameters['vendorId']!)),
      GoRoute(path: '/procurement/rfqs/:id/compare', builder: (context, state) => CompareVendorsScreen(rfqId: state.pathParameters['id']!)),
      GoRoute(path: '/procurement/rfqs/:id/award', builder: (context, state) => AwardDecisionScreen(rfqId: state.pathParameters['id']!)),
      GoRoute(path: '/procurement/rfqs/:id/create-po', builder: (context, state) => CreatePOFromAwardScreen(rfqId: state.pathParameters['id']!)),
      GoRoute(path: '/procurement/pos', builder: (context, state) => const POListScreen()),
      GoRoute(path: '/procurement/pos/:id', builder: (context, state) => PODetailsScreen(poId: state.pathParameters['id']!)),

      // Supplier Routes (existing)
      GoRoute(path: '/supplier', builder: (context, state) => const SupplierDashboard(), routes: [
        GoRoute(path: 'marketplace', builder: (context, state) => const MarketplaceScreen()),
        GoRoute(path: 'rfq/:id', builder: (context, state) => RFQDetailsScreen(rfqId: state.pathParameters['id']!), routes: [
          GoRoute(path: 'quote', builder: (context, state) => QuoteSubmissionScreen(rfqId: state.pathParameters['id']!)),
        ]),
      ]),

      // Supplier Shell + module routes
      GoRoute(path: '/supplier-shell', builder: (context, state) => const SupplierShell()),
      GoRoute(path: '/supplier-shell/dashboard', builder: (context, state) => const SupplierShell()),
      GoRoute(path: '/supplier/opportunities', builder: (context, state) => const OpportunitiesScreen()),
      GoRoute(path: '/supplier/submissions', builder: (context, state) => const SupplierSubmissionsScreen()),
      GoRoute(path: '/supplier/catalog', builder: (context, state) => const CatalogListScreen()),
      GoRoute(path: '/supplier/catalog/new', builder: (context, state) => const AddEditCatalogItemScreen()),
      GoRoute(path: '/supplier/catalog/:id', builder: (context, state) => AddEditCatalogItemScreen(itemId: state.pathParameters['id']!)),
      GoRoute(path: '/supplier/profile/setup', builder: (context, state) => const SupplierProfileSetupScreen()),
      GoRoute(path: '/supplier/profile/verification', builder: (context, state) => const VerificationStatusScreen()),

      // Warehouse Routes (existing)
      GoRoute(path: '/warehouse', builder: (context, state) => const WarehouseDashboard(), routes: [
        GoRoute(path: 'receive', builder: (context, state) => const ReceiveGoodsScreen()),
        GoRoute(path: 'inventory', builder: (context, state) => const WarehouseInventoryScreen()),
        GoRoute(path: 'transfer', builder: (context, state) => const WarehouseTransferScreen()),
        GoRoute(path: 'cycle-count', builder: (context, state) => const WarehouseCycleCountScreen()),
        GoRoute(path: 'dispatch', builder: (context, state) => const WarehouseDispatchScreen()),
        GoRoute(path: 'putaway', builder: (context, state) => const WarehousePutawayScreen()),
      ]),

      // Warehouse Shell + module routes
      GoRoute(path: '/warehouse-shell', builder: (context, state) => const WarehouseShell()),
      GoRoute(path: '/warehouse-shell/dashboard', builder: (context, state) => const WarehouseShell()),
      GoRoute(path: '/warehouse/receiving/select-po', builder: (context, state) => const SelectPOToReceiveScreen()),
      GoRoute(path: '/warehouse/receiving/:poId', builder: (context, state) => ReceiveAgainstPOScreen(poId: state.pathParameters['poId']!)),
      GoRoute(path: '/warehouse/receiving/:poId/grn', builder: (context, state) => GRNSummaryScreen(poId: state.pathParameters['poId']!)),
      GoRoute(path: '/warehouse/movements', builder: (context, state) => const StockMovementHistoryScreen()),
      GoRoute(path: '/warehouse/adjustments/manual', builder: (context, state) => const ManualAdjustmentScreen()),
      GoRoute(path: '/warehouse/locations', builder: (context, state) => const LocationsAndBinsScreen()),
      GoRoute(path: '/warehouse/putaway/task/:id', builder: (context, state) => PutawayTaskDetailScreen(taskId: state.pathParameters['id']!)),

      // Shared / Global
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: '/search', builder: (context, state) => const GlobalSearchScreen()),
      GoRoute(path: '/team', builder: (context, state) => const TeamManagementScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/help', builder: (context, state) => const HelpSupportScreen()),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
}
