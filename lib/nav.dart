import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/role_selection_screen.dart';
import 'screens/procurement/procurement_dashboard.dart';
import 'screens/procurement/create_rfq_screen.dart';
import 'screens/supplier/supplier_dashboard.dart';
import 'screens/supplier/marketplace_screen.dart';
import 'screens/supplier/rfq_details_screen.dart';
import 'screens/supplier/quote_submission_screen.dart';
import 'screens/warehouse/warehouse_dashboard.dart';
import 'screens/warehouse/receive_goods_screen.dart';
import 'screens/warehouse/inventory_screen.dart';
import 'screens/warehouse/transfer_stock_screen.dart';
import 'screens/warehouse/cycle_count_screen.dart';
import 'screens/warehouse/dispatch_screen.dart';
import 'screens/warehouse/putaway_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      
      // Procurement Routes
      GoRoute(
        path: '/procurement',
        builder: (context, state) => const ProcurementDashboard(),
        routes: [
          GoRoute(
            path: 'rfq/create',
            builder: (context, state) => const CreateRFQScreen(),
          ),
        ],
      ),

      // Supplier Routes
      GoRoute(
        path: '/supplier',
        builder: (context, state) => const SupplierDashboard(),
        routes: [
          GoRoute(
            path: 'marketplace',
            builder: (context, state) => const MarketplaceScreen(),
          ),
          GoRoute(
            path: 'rfq/:id',
            builder: (context, state) => RFQDetailsScreen(rfqId: state.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'quote',
                builder: (context, state) => QuoteSubmissionScreen(rfqId: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),

      // Warehouse Routes
      GoRoute(
        path: '/warehouse',
        builder: (context, state) => const WarehouseDashboard(),
        routes: [
          GoRoute(
            path: 'receive',
            builder: (context, state) => const ReceiveGoodsScreen(),
          ),
          GoRoute(
            path: 'inventory',
            builder: (context, state) => const WarehouseInventoryScreen(),
          ),
          GoRoute(
            path: 'transfer',
            builder: (context, state) => const WarehouseTransferScreen(),
          ),
          GoRoute(
            path: 'cycle-count',
            builder: (context, state) => const WarehouseCycleCountScreen(),
          ),
          GoRoute(
            path: 'dispatch',
            builder: (context, state) => const WarehouseDispatchScreen(),
          ),
          GoRoute(
            path: 'putaway',
            builder: (context, state) => const WarehousePutawayScreen(),
          ),
        ],
      ),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
}
