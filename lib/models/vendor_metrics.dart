import 'package:flutter/foundation.dart';

/// Risk level values allowed: low, medium, high
class VendorMetrics {
  final String vendorId;
  final String vendorName;
  final String? logoUrl;

  final double price; // total quote value
  final int deliveryDays;
  final double compliancePercent; // 0-100
  final String riskLevel; // low | medium | high
  final int valueScore; // 0-100
  final double priceVsAverage; // e.g., -8.0 => 8% below avg
  final String submissionStatus; // submitted | pending | declined
  final String paymentTerms; // e.g., Net 30

  final DateTime createdAt;
  final DateTime updatedAt;

  const VendorMetrics({
    required this.vendorId,
    required this.vendorName,
    this.logoUrl,
    required this.price,
    required this.deliveryDays,
    required this.compliancePercent,
    required this.riskLevel,
    required this.valueScore,
    required this.priceVsAverage,
    required this.submissionStatus,
    required this.paymentTerms,
    required this.createdAt,
    required this.updatedAt,
  });

  VendorMetrics copyWith({
    String? vendorId,
    String? vendorName,
    String? logoUrl,
    double? price,
    int? deliveryDays,
    double? compliancePercent,
    String? riskLevel,
    int? valueScore,
    double? priceVsAverage,
    String? submissionStatus,
    String? paymentTerms,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VendorMetrics(
        vendorId: vendorId ?? this.vendorId,
        vendorName: vendorName ?? this.vendorName,
        logoUrl: logoUrl ?? this.logoUrl,
        price: price ?? this.price,
        deliveryDays: deliveryDays ?? this.deliveryDays,
        compliancePercent: compliancePercent ?? this.compliancePercent,
        riskLevel: riskLevel ?? this.riskLevel,
        valueScore: valueScore ?? this.valueScore,
        priceVsAverage: priceVsAverage ?? this.priceVsAverage,
        submissionStatus: submissionStatus ?? this.submissionStatus,
        paymentTerms: paymentTerms ?? this.paymentTerms,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory VendorMetrics.fromJson(Map<String, dynamic> json) => VendorMetrics(
        vendorId: json['vendorId'] as String,
        vendorName: json['vendorName'] as String,
        logoUrl: json['logoUrl'] as String?,
        price: (json['price'] as num).toDouble(),
        deliveryDays: json['deliveryDays'] as int,
        compliancePercent: (json['compliancePercent'] as num).toDouble(),
        riskLevel: json['riskLevel'] as String,
        valueScore: json['valueScore'] as int,
        priceVsAverage: (json['priceVsAverage'] as num).toDouble(),
        submissionStatus: json['submissionStatus'] as String,
        paymentTerms: json['paymentTerms'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'vendorId': vendorId,
        'vendorName': vendorName,
        'logoUrl': logoUrl,
        'price': price,
        'deliveryDays': deliveryDays,
        'compliancePercent': compliancePercent,
        'riskLevel': riskLevel,
        'valueScore': valueScore,
        'priceVsAverage': priceVsAverage,
        'submissionStatus': submissionStatus,
        'paymentTerms': paymentTerms,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
