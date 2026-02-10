
enum UserRole { procurement, supplier, warehouse }
enum RFQStatus { draft, published, closed, awarded }
enum POStatus { issued, acknowledged, inTransit, received, partial }
enum DeliveryStatus { dispatched, inTransit, delivered, delayed }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? companyName; // For suppliers

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.companyName,
  });
}

class Item {
  final String id;
  final String code;
  final String name;
  final String description;
  final String unit; // kg, m, pcs
  final String category;
  final String imageUrl;

  Item({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.unit,
    required this.category,
    required this.imageUrl,
  });
}

class RFQ {
  final String id;
  final String title;
  final String projectId;
  final DateTime createdDate;
  final DateTime deadline;
  final RFQStatus status;
  final List<RFQItem> items;
  final bool isPublic;
  final List<String> invitedSupplierIds;

  RFQ({
    required this.id,
    required this.title,
    required this.projectId,
    required this.createdDate,
    required this.deadline,
    required this.status,
    required this.items,
    this.isPublic = true,
    this.invitedSupplierIds = const [],
  });
}

class RFQItem {
  final String itemId;
  final double quantity;
  final String? specifications; // Additional specs specific to this RFQ

  RFQItem({
    required this.itemId,
    required this.quantity,
    this.specifications,
  });
}

class Quotation {
  final String id;
  final String rfqId;
  final String supplierId;
  final DateTime submissionDate;
  final double totalPrice;
  final List<QuoteItem> items;
  final String status; // pending, accepted, rejected

  Quotation({
    required this.id,
    required this.rfqId,
    required this.supplierId,
    required this.submissionDate,
    required this.totalPrice,
    required this.items,
    this.status = 'pending',
  });
}

class QuoteItem {
  final String itemId;
  final double unitPrice;
  final double quantity;
  final String? remarks;

  QuoteItem({
    required this.itemId,
    required this.unitPrice,
    required this.quantity,
    this.remarks,
  });
}

class PurchaseOrder {
  final String id;
  final String rfqId;
  final String supplierId;
  final DateTime issueDate;
  final double totalAmount;
  final POStatus status;
  final List<POItem> items;

  PurchaseOrder({
    required this.id,
    required this.rfqId,
    required this.supplierId,
    required this.issueDate,
    required this.totalAmount,
    required this.status,
    required this.items,
  });
}

class POItem {
  final String itemId;
  final double quantityOrdered;
  final double quantityReceived;
  final double unitPrice;

  POItem({
    required this.itemId,
    required this.quantityOrdered,
    required this.quantityReceived,
    required this.unitPrice,
  });
}

class Warehouse {
  final String id;
  final String name;
  final String address;

  Warehouse({
    required this.id,
    required this.name,
    required this.address,
  });
}

class Inventory {
  final String id;
  final String warehouseId;
  final String itemId;
  final double quantityOnHand;
  final double minStockLevel;

  Inventory({
    required this.id,
    required this.warehouseId,
    required this.itemId,
    required this.quantityOnHand,
    required this.minStockLevel,
  });
}

class Delivery {
  final String id;
  final String poId;
  final DateTime estimatedDeliveryDate;
  final DateTime? actualDeliveryDate;
  final DeliveryStatus status;
  final String trackingNumber;

  Delivery({
    required this.id,
    required this.poId,
    required this.estimatedDeliveryDate,
    this.actualDeliveryDate,
    required this.status,
    required this.trackingNumber,
  });
}
