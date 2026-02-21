import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:siteflow/models/vendor_metrics.dart';
import 'package:siteflow/models/scorecard_metrics.dart';

class DecisionIntelligenceService {
  static final DecisionIntelligenceService _instance = DecisionIntelligenceService._internal();
  factory DecisionIntelligenceService() => _instance;
  DecisionIntelligenceService._internal();

  final _rand = Random(42);

  // Mock: Get vendors with decision metrics for a given RFQ
  Future<List<VendorMetrics>> getRfqDecisionVendors(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('DecisionIntelligenceService.getRfqDecisionVendors(rfqId=$rfqId)');
    final now = DateTime.now();
    return List.generate(12, (i) {
      final price = 80000 + _rand.nextInt(60000);
      final avg = 100000;
      final priceVsAvg = ((price - avg) / avg * 100).toDouble();
      final risk = ['low', 'medium', 'high'][_rand.nextInt(3)];
      final valueScore = (70 + _rand.nextInt(31));
      final compliance = 70 + _rand.nextInt(31);
      final submitted = _rand.nextBool();
      return VendorMetrics(
        vendorId: 'v${i + 1}',
        vendorName: 'Vendor ${i + 1}',
        logoUrl: null,
        price: price.toDouble(),
        deliveryDays: 5 + _rand.nextInt(20),
        compliancePercent: compliance.toDouble(),
        riskLevel: risk,
        valueScore: valueScore,
        priceVsAverage: priceVsAvg,
        submissionStatus: submitted ? 'submitted' : (_rand.nextBool() ? 'pending' : 'declined'),
        paymentTerms: _rand.nextBool() ? 'Net 30' : 'Net 45',
        createdAt: now,
        updatedAt: now,
      );
    });
  }

  // Mock: Get vendor scorecard metrics
  Future<ScorecardMetrics> getVendorScorecard(String vendorId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    debugPrint('DecisionIntelligenceService.getVendorScorecard(vendorId=$vendorId)');
    final now = DateTime.now();
    final base = vendorId.codeUnitAt(vendorId.length - 1) % 10;
    List<double> trend(int start) => List<double>.generate(6, (i) => (start + i * 3 + (i % 2 == 0 ? 5 : -3)).toDouble().clamp(0, 100));
    return ScorecardMetrics(
      vendorId: vendorId,
      vendorName: 'Vendor ${vendorId.replaceAll(RegExp(r'[^0-9]'), '')}',
      category: ['Concrete', 'Metal', 'Electrical'][base % 3],
      location: ['Dubai', 'Riyadh', 'Doha', 'Abu Dhabi'][base % 4],
      reliability: 65 + (base % 30),
      onTimeRate: 70 + (base % 25),
      awardRate: 15 + (base % 35),
      deviationRate: (base % 12) + 4,
      disputeRate: (base % 6) + 1,
      onTimeTrend: trend(60 + (base % 10)),
      priceDeviationTrend: trend(8 + (base % 6)).map((e) => (e / 2)).toList(),
      createdAt: now,
      updatedAt: now,
    );
  }

  // Mock: Supplier self performance mirrors vendor scorecard
  Future<ScorecardMetrics> getSupplierPerformance(String supplierId) async {
    return getVendorScorecard(supplierId);
  }
}
