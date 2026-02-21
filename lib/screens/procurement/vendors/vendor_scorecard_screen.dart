import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:siteflow/models/scorecard_metrics.dart';
import 'package:siteflow/services/decision_intelligence_service.dart';
import 'package:go_router/go_router.dart';

class VendorScorecardScreen extends StatefulWidget {
  final String vendorId;
  const VendorScorecardScreen({super.key, required this.vendorId});

  @override
  State<VendorScorecardScreen> createState() => _VendorScorecardScreenState();
}

class _VendorScorecardScreenState extends State<VendorScorecardScreen> {
  final _svc = DecisionIntelligenceService();
  ScorecardMetrics? _m;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final m = await _svc.getVendorScorecard(widget.vendorId);
    if (mounted) setState(() => _m = m);
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final m = _m;
    return Scaffold(
      appBar: AppBar(
        title: Text(m == null ? 'Vendor Scorecard' : '${m.vendorName} — Scorecard'),
        actions: [
          if (m != null)
            TextButton.icon(
              onPressed: () => context.push('/procurement-shell/rfqs/NEW/invite?prefillVendor=${m.vendorId}'),
              icon: const Icon(Icons.mail_outline),
              label: const Text('Invite to RFQ'),
            )
        ],
      ),
      body: m == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const CircleAvatar(child: Icon(Icons.store)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(m.vendorName, style: ts.titleLarge),
                    Text('${m.category} • ${m.location}', style: ts.bodySmall?.copyWith(color: Colors.grey[700])),
                  ])),
                ]),
                const SizedBox(height: 16),
                // KPI tiles
                Row(children: [
                  Expanded(child: _KpiTile(title: 'Reliability', value: '${m.reliability}', icon: Icons.verified, color: Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _KpiTile(title: 'On-time', value: '${m.onTimeRate.toStringAsFixed(0)}%', icon: Icons.schedule, color: Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _KpiTile(title: 'Award rate', value: '${m.awardRate.toStringAsFixed(0)}%', icon: Icons.workspace_premium, color: Colors.orange)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _KpiTile(title: 'Avg deviation', value: '${m.deviationRate.toStringAsFixed(1)}%', icon: Icons.price_change, color: Colors.purple)),
                  const SizedBox(width: 12),
                  Expanded(child: _KpiTile(title: 'Dispute rate', value: '${m.disputeRate.toStringAsFixed(1)}%', icon: Icons.report_gmailerrorred, color: Colors.red)),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()),
                ]),
                const SizedBox(height: 24),
                // Charts
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('On-time Delivery Trend', style: ts.titleMedium),
                      const SizedBox(height: 8),
                      SizedBox(height: 160, child: LineChart(LineChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: cs.primary,
                            barWidth: 3,
                            spots: [
                              for (int i = 0; i < m.onTimeTrend.length; i++) FlSpot(i.toDouble(), m.onTimeTrend[i])
                            ],
                          )
                        ],
                      ))),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Price Deviation Trend', style: ts.titleMedium),
                      const SizedBox(height: 8),
                      SizedBox(height: 160, child: LineChart(LineChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.orange,
                            barWidth: 3,
                            spots: [
                              for (int i = 0; i < m.priceDeviationTrend.length; i++) FlSpot(i.toDouble(), m.priceDeviationTrend[i])
                            ],
                          )
                        ],
                      ))),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                // Strengths and Risks
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Expanded(child: _BulletsCard(title: 'Strengths', bullets: [
                    'Consistent on-time deliveries in the last 3 months',
                    'Competitive pricing vs market average',
                    'Strong communication and documentation quality',
                  ])),
                  SizedBox(width: 12),
                  Expanded(child: _BulletsCard(title: 'Risks', bullets: [
                    'Slight increase in price deviation last month',
                    'Limited capacity during peak seasons',
                  ])),
                ]),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Suggested action', style: ts.titleMedium),
                      const SizedBox(height: 8),
                      Text('Shortlist the vendor for upcoming RFQs and negotiate for Net 30 terms to improve total value score.', style: ts.bodyMedium),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: () => context.push('/procurement-shell/rfqs/NEW/invite?prefillVendor=${m.vendorId}'),
                          icon: const Icon(Icons.mail_outline),
                          label: const Text('Invite to RFQ'),
                        ),
                      )
                    ]),
                  ),
                ),
              ]),
            ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String title; final String value; final IconData icon; final Color color;
  const _KpiTile({required this.title, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08)),
      ),
      child: Row(children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey[700])),
        ])
      ]),
    );
  }
}

class _BulletsCard extends StatelessWidget {
  final String title; final List<String> bullets; const _BulletsCard({required this.title, required this.bullets});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.circle, size: 6),
                  const SizedBox(width: 8),
                  Expanded(child: Text(b)),
                ]),
              )),
        ]),
      ),
    );
  }
}
