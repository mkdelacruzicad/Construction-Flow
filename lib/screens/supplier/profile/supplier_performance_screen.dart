import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:siteflow/services/decision_intelligence_service.dart';
import 'package:siteflow/models/scorecard_metrics.dart';
import 'package:siteflow/services/mock_data_service.dart';

class SupplierPerformanceScreen extends StatefulWidget {
  const SupplierPerformanceScreen({super.key});

  @override
  State<SupplierPerformanceScreen> createState() => _SupplierPerformanceScreenState();
}

class _SupplierPerformanceScreenState extends State<SupplierPerformanceScreen> {
  final _svc = DecisionIntelligenceService();
  ScorecardMetrics? _m;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final currentUser = context.read<MockDataService>().currentUser;
    final id = currentUser?.id ?? 'self';
    final m = await _svc.getSupplierPerformance(id);
    if (mounted) setState(() => _m = m);
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final m = _m;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Performance')),
      body: m == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const CircleAvatar(child: Icon(Icons.emoji_events)),
                  const SizedBox(width: 12),
                  Text('Performance overview', style: ts.titleLarge),
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: _Kpi(title: 'Reliability', value: '${m.reliability}', icon: Icons.verified, color: Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _Kpi(title: 'On-time', value: '${m.onTimeRate.toStringAsFixed(0)}%', icon: Icons.schedule, color: Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _Kpi(title: 'Award rate', value: '${m.awardRate.toStringAsFixed(0)}%', icon: Icons.workspace_premium, color: Colors.orange)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _Kpi(title: 'Avg deviation', value: '${m.deviationRate.toStringAsFixed(1)}%', icon: Icons.price_change, color: Colors.purple)),
                  const SizedBox(width: 12),
                  Expanded(child: _Kpi(title: 'Dispute rate', value: '${m.disputeRate.toStringAsFixed(1)}%', icon: Icons.report, color: Colors.red)),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()),
                ]),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('On-time Delivery Trend'),
                      const SizedBox(height: 8),
                      SizedBox(height: 160, child: LineChart(LineChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true, color: Theme.of(context).colorScheme.primary, barWidth: 3,
                            spots: [for (int i = 0; i < m.onTimeTrend.length; i++) FlSpot(i.toDouble(), m.onTimeTrend[i])],
                          )
                        ],
                      )))
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Price Deviation Trend'),
                      const SizedBox(height: 8),
                      SizedBox(height: 160, child: LineChart(LineChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true, color: Colors.orange, barWidth: 3,
                            spots: [for (int i = 0; i < m.priceDeviationTrend.length; i++) FlSpot(i.toDouble(), m.priceDeviationTrend[i])],
                          )
                        ],
                      )))
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('How to improve your score', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('• Confirm delivery slots earlier to reduce delays.') ,
                      SizedBox(height: 4),
                      Text('• Offer Net 30 terms to increase award rate.'),
                      SizedBox(height: 4),
                      Text('• Keep price deviation within +/-5% of average.'),
                    ]),
                  ),
                )
              ]),
            ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String title; final String value; final IconData icon; final Color color;
  const _Kpi({required this.title, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Row(children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey)),
        ])
      ]),
    );
  }
}
