class ScorecardMetrics {
  final String vendorId;
  final String vendorName;
  final String category;
  final String location;

  // KPIs
  final int reliability; // 0-100
  final double onTimeRate; // percentage 0-100
  final double awardRate; // percentage 0-100
  final double deviationRate; // avg price deviation %
  final double disputeRate; // percentage 0-100

  // Trends (mock)
  final List<double> onTimeTrend; // monthly
  final List<double> priceDeviationTrend; // monthly

  final DateTime createdAt;
  final DateTime updatedAt;

  const ScorecardMetrics({
    required this.vendorId,
    required this.vendorName,
    required this.category,
    required this.location,
    required this.reliability,
    required this.onTimeRate,
    required this.awardRate,
    required this.deviationRate,
    required this.disputeRate,
    required this.onTimeTrend,
    required this.priceDeviationTrend,
    required this.createdAt,
    required this.updatedAt,
  });

  ScorecardMetrics copyWith({
    String? vendorId,
    String? vendorName,
    String? category,
    String? location,
    int? reliability,
    double? onTimeRate,
    double? awardRate,
    double? deviationRate,
    double? disputeRate,
    List<double>? onTimeTrend,
    List<double>? priceDeviationTrend,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ScorecardMetrics(
        vendorId: vendorId ?? this.vendorId,
        vendorName: vendorName ?? this.vendorName,
        category: category ?? this.category,
        location: location ?? this.location,
        reliability: reliability ?? this.reliability,
        onTimeRate: onTimeRate ?? this.onTimeRate,
        awardRate: awardRate ?? this.awardRate,
        deviationRate: deviationRate ?? this.deviationRate,
        disputeRate: disputeRate ?? this.disputeRate,
        onTimeTrend: onTimeTrend ?? this.onTimeTrend,
        priceDeviationTrend: priceDeviationTrend ?? this.priceDeviationTrend,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ScorecardMetrics.fromJson(Map<String, dynamic> json) => ScorecardMetrics(
        vendorId: json['vendorId'] as String,
        vendorName: json['vendorName'] as String,
        category: json['category'] as String,
        location: json['location'] as String,
        reliability: json['reliability'] as int,
        onTimeRate: (json['onTimeRate'] as num).toDouble(),
        awardRate: (json['awardRate'] as num).toDouble(),
        deviationRate: (json['deviationRate'] as num).toDouble(),
        disputeRate: (json['disputeRate'] as num).toDouble(),
        onTimeTrend: (json['onTimeTrend'] as List).map((e) => (e as num).toDouble()).toList(),
        priceDeviationTrend: (json['priceDeviationTrend'] as List).map((e) => (e as num).toDouble()).toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'vendorId': vendorId,
        'vendorName': vendorName,
        'category': category,
        'location': location,
        'reliability': reliability,
        'onTimeRate': onTimeRate,
        'awardRate': awardRate,
        'deviationRate': deviationRate,
        'disputeRate': disputeRate,
        'onTimeTrend': onTimeTrend,
        'priceDeviationTrend': priceDeviationTrend,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
