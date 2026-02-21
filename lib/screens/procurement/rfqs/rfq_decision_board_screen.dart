import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siteflow/models/vendor_metrics.dart';
import 'package:siteflow/services/decision_intelligence_service.dart';

class RFQDecisionBoardScreen extends StatefulWidget {
  final String rfqId;
  const RFQDecisionBoardScreen({super.key, required this.rfqId});

  @override
  State<RFQDecisionBoardScreen> createState() => _RFQDecisionBoardScreenState();
}

class _RFQDecisionBoardScreenState extends State<RFQDecisionBoardScreen> {
  final _svc = DecisionIntelligenceService();
  List<VendorMetrics> _vendors = [];
  bool _loading = true;

  // UI state
  final Set<String> _pinned = {};
  final Set<String> _shortlisted = {};
  final Set<String> _compare = {};

  String _sort = 'best_value';
  String _statusFilter = 'all';
  String _riskFilter = 'all';
  bool _shortlistedOnly = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _svc.getRfqDecisionVendors(widget.rfqId);
      setState(() => _vendors = res);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<VendorMetrics> get _processedVendors {
    Iterable<VendorMetrics> list = _vendors;
    if (_statusFilter != 'all') list = list.where((v) => v.submissionStatus == _statusFilter);
    if (_riskFilter != 'all') list = list.where((v) => v.riskLevel == _riskFilter);
    if (_shortlistedOnly) list = list.where((v) => _shortlisted.contains(v.vendorId));

    final l = list.toList();
    switch (_sort) {
      case 'lowest_price':
        l.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'fastest_delivery':
        l.sort((a, b) => a.deliveryDays.compareTo(b.deliveryDays));
        break;
      case 'highest_compliance':
        l.sort((a, b) => b.compliancePercent.compareTo(a.compliancePercent));
        break;
      case 'lowest_risk':
        int rank(String r) => {'low': 0, 'medium': 1, 'high': 2}[r] ?? 3;
        l.sort((a, b) => rank(a.riskLevel).compareTo(rank(b.riskLevel)));
        break;
      default:
        l.sort((a, b) => b.valueScore.compareTo(a.valueScore));
    }

    // Pinned to top
    l.sort((a, b) {
      final ap = _pinned.contains(a.vendorId) ? 0 : 1;
      final bp = _pinned.contains(b.vendorId) ? 0 : 1;
      return ap.compareTo(bp);
    });
    return l;
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final invited = _vendors.length;
    final submitted = _vendors.where((v) => v.submissionStatus == 'submitted').length;
    final avg = _vendors.isEmpty ? 0 : _vendors.map((e) => e.price).reduce((a, b) => a + b) / _vendors.length;
    final best = _vendors.isEmpty ? 0 : _vendors.map((e) => e.price).reduce((a, b) => a < b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: Text('RFQ ${widget.rfqId} • Decision Board', style: ts.titleLarge),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header + KPIs
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(child: Text('RFQ Title (mock)', style: ts.headlineSmall)),
                        _StatusChip(label: 'Open', color: Colors.green),
                        const SizedBox(width: 8),
                        Row(children: [const Icon(Icons.schedule, size: 18), const SizedBox(width: 4), Text('Deadline: Oct 31')]),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: _KpiCard(icon: Icons.group, label: 'Vendors Invited', value: invited.toString())),
                        const SizedBox(width: 12),
                        Expanded(child: _KpiCard(icon: Icons.inbox, label: 'Submissions', value: submitted.toString())),
                        const SizedBox(width: 12),
                        Expanded(child: _KpiCard(icon: Icons.attach_money, label: 'Avg Quote', value: avg == 0 ? '-' : '\$${avg.toStringAsFixed(0)}')),
                        const SizedBox(width: 12),
                        Expanded(child: _KpiCard(icon: Icons.star, label: 'Best Quote', value: best == 0 ? '-' : '\$${best.toStringAsFixed(0)}')),
                      ]),
                      const SizedBox(height: 16),
                      Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                        // Sorting
                        DropdownButton<String>(
                          value: _sort,
                          items: const [
                            DropdownMenuItem(value: 'best_value', child: Text('Best Value Score')),
                            DropdownMenuItem(value: 'lowest_price', child: Text('Lowest Price')),
                            DropdownMenuItem(value: 'fastest_delivery', child: Text('Fastest Delivery')),
                            DropdownMenuItem(value: 'highest_compliance', child: Text('Highest Compliance')),
                            DropdownMenuItem(value: 'lowest_risk', child: Text('Lowest Risk')),
                          ],
                          onChanged: (v) => setState(() => _sort = v ?? 'best_value'),
                        ),
                        const SizedBox(width: 8),
                        // Filters
                        _FilterChip<String>(
                          label: 'Status',
                          value: _statusFilter,
                          options: const [
                            ('all', 'All'),
                            ('submitted', 'Submitted'),
                            ('pending', 'Pending'),
                            ('declined', 'Declined'),
                          ],
                          onChanged: (v) => setState(() => _statusFilter = v),
                        ),
                        _FilterChip<String>(
                          label: 'Risk',
                          value: _riskFilter,
                          options: const [
                            ('all', 'All'),
                            ('low', 'Low'),
                            ('medium', 'Medium'),
                            ('high', 'High'),
                          ],
                          onChanged: (v) => setState(() => _riskFilter = v),
                        ),
                        FilterChip(
                          label: const Text('Shortlisted only'),
                          selected: _shortlistedOnly,
                          onSelected: (s) => setState(() => _shortlistedOnly = s),
                        ),
                      ]),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Grid of vendor cards
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: GridView.builder(
                      key: ValueKey('${_sort}_${_statusFilter}_${_riskFilter}_${_shortlistedOnly}_${_pinned.length}')
                        ,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _processedVendors.length,
                      itemBuilder: (context, i) {
                        final v = _processedVendors[i];
                        final isPinned = _pinned.contains(v.vendorId);
                        final isShort = _shortlisted.contains(v.vendorId);
                        final inCompare = _compare.contains(v.vendorId);
                        return AnimatedScale(
                          duration: const Duration(milliseconds: 180),
                          scale: isPinned ? 1.02 : 1.0,
                          child: _VendorCard(
                            v: v,
                            pinned: isPinned,
                            shortlisted: isShort,
                            inCompare: inCompare,
                            onPinToggle: () => setState(() => isPinned ? _pinned.remove(v.vendorId) : _pinned.add(v.vendorId)),
                            onShortlistToggle: () => setState(() => isShort ? _shortlisted.remove(v.vendorId) : _shortlisted.add(v.vendorId)),
                            onCompareToggle: () => setState(() {
                              if (inCompare) {
                                _compare.remove(v.vendorId);
                              } else if (_compare.length < 3) {
                                _compare.add(v.vendorId);
                              }
                            }),
                            onOpenScorecard: () => context.push('/procurement-shell/vendors/${v.vendorId}/scorecard'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _compare.isEmpty
          ? null
          : _CompareTray(
              count: _compare.length,
              onClear: () => setState(() => _compare.clear()),
              onCompare: () => context.push('/procurement-shell/rfqs/${widget.rfqId}/compare'),
            ),
      floatingActionButton: _vendors.isEmpty
          ? null
          : _AwardPanel(
              vendors: _vendors,
              onProceed: (selectedId) => context.push('/procurement-shell/rfqs/${widget.rfqId}/award'),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _KpiCard({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey)),
          ])
        ]),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label; final Color color; const _StatusChip({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
      );
}

class _FilterChip<T> extends StatelessWidget {
  final String label; final T value; final List<(T, String)> options; final ValueChanged<T> onChanged;
  const _FilterChip({required this.label, required this.value, required this.options, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('$label:'),
      const SizedBox(width: 6),
      DropdownButton<T>(
        value: value,
        items: options.map((o) => DropdownMenuItem<T>(value: o.$1, child: Text(o.$2))).toList(),
        onChanged: (v) { if (v != null) onChanged(v); },
      ),
    ]);
  }
}

class _VendorCard extends StatelessWidget {
  final VendorMetrics v;
  final bool pinned;
  final bool shortlisted;
  final bool inCompare;
  final VoidCallback onPinToggle;
  final VoidCallback onShortlistToggle;
  final VoidCallback onCompareToggle;
  final VoidCallback onOpenScorecard;
  const _VendorCard({super.key, required this.v, required this.pinned, required this.shortlisted, required this.inCompare, required this.onPinToggle, required this.onShortlistToggle, required this.onCompareToggle, required this.onOpenScorecard});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color riskColor(String r) => switch (r) { 'low' => Colors.green, 'medium' => Colors.orange, _ => Colors.red };
    final isBelowAvg = v.priceVsAverage < 0;
    final priceBadgeColor = isBelowAvg ? Colors.green : Colors.orange;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpenScorecard,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(child: Icon(Icons.store, size: 18)),
              const SizedBox(width: 8),
              Expanded(child: Text(v.vendorName, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium)),
              Tooltip(message: pinned ? 'Unpin' : 'Pin', child: IconButton(onPressed: onPinToggle, icon: Icon(pinned ? Icons.push_pin : Icons.push_pin_outlined))),
              Tooltip(message: shortlisted ? 'Remove from shortlist' : 'Shortlist', child: IconButton(onPressed: onShortlistToggle, icon: Icon(shortlisted ? Icons.star : Icons.star_border))),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              _Chip(text: v.submissionStatus, color: v.submissionStatus == 'submitted' ? Colors.green : (v.submissionStatus == 'pending' ? Colors.orange : Colors.grey)),
              const SizedBox(width: 6),
              _Chip(text: 'Risk: ${v.riskLevel}', color: riskColor(v.riskLevel)),
              const SizedBox(width: 6),
              _Chip(text: '${v.priceVsAverage.toStringAsFixed(0)}%', color: priceBadgeColor),
            ]),
            const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('\$${v.price.toStringAsFixed(0)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Text('${v.deliveryDays} days • ${v.paymentTerms}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
            ]),
            const SizedBox(height: 12),
            // Compliance progress + Value score donut
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Compliance', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: v.compliancePercent / 100,
                    color: Colors.green,
                    backgroundColor: Colors.green.withValues(alpha: 0.15),
                  ),
                ),
              ])),
              const SizedBox(width: 12),
              SizedBox(
                width: 56, height: 56,
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(value: v.valueScore / 100, color: cs.primary, backgroundColor: cs.primary.withValues(alpha: 0.15)),
                  Text('${v.valueScore}', style: Theme.of(context).textTheme.labelLarge),
                ]),
              ),
            ]),
            const Spacer(),
            Row(children: [
              OutlinedButton.icon(onPressed: onCompareToggle, icon: Icon(inCompare ? Icons.check_circle : Icons.add_circle_outline), label: const Text('Compare')),
              const SizedBox(width: 8),
              TextButton(onPressed: onOpenScorecard, child: const Text('View scorecard')),
            ])
          ]),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text; final Color color; const _Chip({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
        child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
      );
}

class _CompareTray extends StatelessWidget {
  final int count; final VoidCallback onCompare; final VoidCallback onClear; const _CompareTray({required this.count, required this.onCompare, required this.onClear});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, border: Border(top: BorderSide(color: cs.outline.withValues(alpha: 0.12))))
      ,
      child: Row(children: [
        Text('Selected: $count'),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: onClear, child: const Text('Clear')),
        const Spacer(),
        FilledButton.icon(onPressed: onCompare, icon: const Icon(Icons.table_chart), label: const Text('Compare Selected')),
      ]),
    );
  }
}

class _AwardPanel extends StatelessWidget {
  final List<VendorMetrics> vendors; final void Function(String vendorId) onProceed; const _AwardPanel({required this.vendors, required this.onProceed});
  @override
  Widget build(BuildContext context) {
    // Mock recommendation: highest value score with low risk
    List<VendorMetrics> sorted = [...vendors];
    sorted.sort((a, b) {
      int score(VendorMetrics v) => (v.valueScore * 10) - ({'low': 0, 'medium': 5, 'high': 15}[v.riskLevel] ?? 0);
      return score(b).compareTo(score(a));
    });
    final rec = sorted.firstOrNull ?? vendors.first;
    return FloatingActionButton.extended(
      onPressed: () => onProceed(rec.vendorId),
      icon: const Icon(Icons.workspace_premium),
      label: Text('Proceed to Award • ${rec.vendorName}'),
    );
  }
}

extension FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
