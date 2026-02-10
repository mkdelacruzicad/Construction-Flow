import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/data_models.dart';

class MockDataService extends ChangeNotifier {
  final _uuid = const Uuid();

  // --- Mock Data ---
  final List<User> _users = [
    User(id: 'u1', name: 'John Doe', email: 'john@construct.com', role: UserRole.procurement),
    User(id: 'u2', name: 'BuildSupply Co.', email: 'sales@buildsupply.com', role: UserRole.supplier, companyName: 'BuildSupply Co.'),
    User(id: 'u3', name: 'Warehouser Mike', email: 'mike@construct.com', role: UserRole.warehouse),
  ];

  // Simple in-memory credentials (email -> password)
  final Map<String, String> _passwords = {
    'john@construct.com': 'password123',
    'sales@buildsupply.com': 'password123',
    'mike@construct.com': 'password123',
  };

  final List<Item> _items = [
    Item(id: 'i1', code: 'CEM-001', name: 'Portland Cement (50kg)', description: 'High quality Portland cement for general use', unit: 'bag', category: 'Raw Materials', imageUrl: 'https://placehold.co/100x100?text=Cement'),
    Item(id: 'i2', code: 'STL-Bar-12', name: 'Steel Rebar 12mm', description: 'Deformed steel reinforcement bar', unit: 'ton', category: 'Steel', imageUrl: 'https://placehold.co/100x100?text=Steel'),
    Item(id: 'i3', code: 'BRK-Red', name: 'Red Clay Bricks', description: 'Standard kiln-fired red bricks', unit: 'pallet', category: 'Masonry', imageUrl: 'https://placehold.co/100x100?text=Bricks'),
    Item(id: 'i4', code: 'SND-Riv', name: 'River Sand', description: 'Washed river sand for concrete mix', unit: 'm3', category: 'Aggregates', imageUrl: 'https://placehold.co/100x100?text=Sand'),
    Item(id: 'i5', code: 'TIM-Ply', name: 'Plywood Sheet 18mm', description: 'Marine grade plywood', unit: 'sheet', category: 'Timber', imageUrl: 'https://placehold.co/100x100?text=Wood'),
  ];

  final List<RFQ> _rfqs = [];
  final List<Quotation> _quotations = [];
  final List<PurchaseOrder> _purchaseOrders = [];
  final List<Warehouse> _warehouses = [
    Warehouse(id: 'w1', name: 'Central Depot', address: '123 Industrial Ave'),
    Warehouse(id: 'w2', name: 'Site A Store', address: 'Project Site A, Downtown'),
  ];
  final List<Inventory> _inventory = [];

  // --- Getters ---
  List<User> get users => List.unmodifiable(_users);
  List<Item> get items => List.unmodifiable(_items);
  List<RFQ> get rfqs => List.unmodifiable(_rfqs);
  List<Quotation> get quotations => List.unmodifiable(_quotations);
  List<PurchaseOrder> get purchaseOrders => List.unmodifiable(_purchaseOrders);
  List<Warehouse> get warehouses => List.unmodifiable(_warehouses);
  List<Inventory> get inventory => List.unmodifiable(_inventory);

  User? _currentUser;
  User? get currentUser => _currentUser;

  MockDataService() {
    _initMockData();
  }

  void _initMockData() {
    // Initial inventory
    _inventory.add(Inventory(id: 'inv1', warehouseId: 'w1', itemId: 'i1', quantityOnHand: 500, minStockLevel: 100));
    _inventory.add(Inventory(id: 'inv2', warehouseId: 'w1', itemId: 'i2', quantityOnHand: 20, minStockLevel: 5));
    _inventory.add(Inventory(id: 'inv3', warehouseId: 'w2', itemId: 'i3', quantityOnHand: 1000, minStockLevel: 200));

    // Initial RFQs
    _rfqs.add(RFQ(
      id: 'rfq1',
      title: 'Foundation Materials - Site A',
      projectId: 'PRJ-001',
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      deadline: DateTime.now().add(const Duration(days: 2)),
      status: RFQStatus.published,
      items: [
        RFQItem(itemId: 'i1', quantity: 200),
        RFQItem(itemId: 'i2', quantity: 10),
      ],
      isPublic: true,
    ));

    _rfqs.add(RFQ(
      id: 'rfq2',
      title: 'Brickwork Phase 1',
      projectId: 'PRJ-002',
      createdDate: DateTime.now().subtract(const Duration(days: 10)),
      deadline: DateTime.now().subtract(const Duration(days: 1)),
      status: RFQStatus.closed,
      items: [
        RFQItem(itemId: 'i3', quantity: 5000),
      ],
      isPublic: true,
    ));
  }

  // --- Actions ---

  void login(UserRole role) {
    _currentUser = _users.firstWhere((u) => u.role == role);
    notifyListeners();
  }

  /// Email/password login constrained by role. Returns true if success.
  bool loginWithEmail({required String email, required String password, required UserRole role}) {
    try {
      final user = _users.firstWhere((u) => u.email.toLowerCase() == email.toLowerCase() && u.role == role);
      final expected = _passwords[email.toLowerCase()];
      if (expected != null && expected == password) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('loginWithEmail error: $e');
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void createRFQ(String title, String projectId, DateTime deadline, List<RFQItem> items) {
    final rfq = RFQ(
      id: _uuid.v4(),
      title: title,
      projectId: projectId,
      createdDate: DateTime.now(),
      deadline: deadline,
      status: RFQStatus.published,
      items: items,
      isPublic: true,
    );
    _rfqs.insert(0, rfq);
    notifyListeners();
  }

  void submitQuotation(String rfqId, double totalPrice, List<QuoteItem> items) {
    if (_currentUser?.role != UserRole.supplier) return;
    final quote = Quotation(
      id: _uuid.v4(),
      rfqId: rfqId,
      supplierId: _currentUser!.id,
      submissionDate: DateTime.now(),
      totalPrice: totalPrice,
      items: items,
      status: 'pending',
    );
    _quotations.add(quote);
    notifyListeners();
  }

  void awardRFQ(String rfqId, String quoteId) {
    // Find the quote
    final quote = _quotations.firstWhere((q) => q.id == quoteId);
    
    // Create PO
    final po = PurchaseOrder(
      id: _uuid.v4(),
      rfqId: rfqId,
      supplierId: quote.supplierId,
      issueDate: DateTime.now(),
      totalAmount: quote.totalPrice,
      status: POStatus.issued,
      items: quote.items.map((qi) => POItem(
        itemId: qi.itemId,
        quantityOrdered: qi.quantity,
        quantityReceived: 0,
        unitPrice: qi.unitPrice,
      )).toList(),
    );
    _purchaseOrders.add(po);

    // Update RFQ status
    // In a real app, we'd find the index and update
    // Here simplified
    final rfqIndex = _rfqs.indexWhere((r) => r.id == rfqId);
    if (rfqIndex != -1) {
       // Ideally copyWith but models are simple for now
    }

    notifyListeners();
  }

  void receiveGoods(String poId, String itemId, double quantity, String warehouseId) {
    final poIndex = _purchaseOrders.indexWhere((p) => p.id == poId);
    if (poIndex == -1) return;

    // Update Inventory
    final existingInvIndex = _inventory.indexWhere((inv) => inv.warehouseId == warehouseId && inv.itemId == itemId);
    if (existingInvIndex != -1) {
      final oldInv = _inventory[existingInvIndex];
      _inventory[existingInvIndex] = Inventory(
        id: oldInv.id,
        warehouseId: oldInv.warehouseId,
        itemId: oldInv.itemId,
        quantityOnHand: oldInv.quantityOnHand + quantity,
        minStockLevel: oldInv.minStockLevel,
      );
    } else {
      _inventory.add(Inventory(
        id: _uuid.v4(),
        warehouseId: warehouseId,
        itemId: itemId,
        quantityOnHand: quantity,
        minStockLevel: 0,
      ));
    }
    
    // Update PO status logic omitted for brevity
    notifyListeners();
  }

  // -----------------------------
  // Warehouse Operations (Mock)
  // -----------------------------

  /// Transfer stock between warehouses. Returns true on success.
  bool transferStock({
    required String itemId,
    required String fromWarehouseId,
    required String toWarehouseId,
    required double quantity,
  }) {
    try {
      if (quantity <= 0) return false;

      // Deduct from source
      final fromIndex = _inventory.indexWhere((inv) => inv.warehouseId == fromWarehouseId && inv.itemId == itemId);
      if (fromIndex == -1) return false;
      final fromInv = _inventory[fromIndex];
      if (fromInv.quantityOnHand < quantity) return false;

      _inventory[fromIndex] = Inventory(
        id: fromInv.id,
        warehouseId: fromInv.warehouseId,
        itemId: fromInv.itemId,
        quantityOnHand: fromInv.quantityOnHand - quantity,
        minStockLevel: fromInv.minStockLevel,
      );

      // Add to destination
      final toIndex = _inventory.indexWhere((inv) => inv.warehouseId == toWarehouseId && inv.itemId == itemId);
      if (toIndex != -1) {
        final toInv = _inventory[toIndex];
        _inventory[toIndex] = Inventory(
          id: toInv.id,
          warehouseId: toInv.warehouseId,
          itemId: toInv.itemId,
          quantityOnHand: toInv.quantityOnHand + quantity,
          minStockLevel: toInv.minStockLevel,
        );
      } else {
        _inventory.add(Inventory(
          id: _uuid.v4(),
          warehouseId: toWarehouseId,
          itemId: itemId,
          quantityOnHand: quantity,
          minStockLevel: 0,
        ));
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('transferStock error: $e');
      return false;
    }
  }

  /// Adjust stock to a new absolute quantity (cycle count)
  bool adjustStock({
    required String warehouseId,
    required String itemId,
    required double newQuantity,
  }) {
    try {
      if (newQuantity < 0) return false;
      final index = _inventory.indexWhere((inv) => inv.warehouseId == warehouseId && inv.itemId == itemId);
      if (index == -1) return false;
      final inv = _inventory[index];
      _inventory[index] = Inventory(
        id: inv.id,
        warehouseId: inv.warehouseId,
        itemId: inv.itemId,
        quantityOnHand: newQuantity,
        minStockLevel: inv.minStockLevel,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('adjustStock error: $e');
      return false;
    }
  }

  /// Dispatch (issue) stock to a project/site: reduces on-hand
  bool dispatchStock({
    required String warehouseId,
    required String itemId,
    required double quantity,
  }) {
    try {
      if (quantity <= 0) return false;
      final index = _inventory.indexWhere((inv) => inv.warehouseId == warehouseId && inv.itemId == itemId);
      if (index == -1) return false;
      final inv = _inventory[index];
      if (inv.quantityOnHand < quantity) return false;
      _inventory[index] = Inventory(
        id: inv.id,
        warehouseId: inv.warehouseId,
        itemId: inv.itemId,
        quantityOnHand: inv.quantityOnHand - quantity,
        minStockLevel: inv.minStockLevel,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('dispatchStock error: $e');
      return false;
    }
  }
}
