import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';

class QuoteSubmissionScreen extends StatefulWidget {
  final String rfqId;

  const QuoteSubmissionScreen({super.key, required this.rfqId});

  @override
  _QuoteSubmissionScreenState createState() => _QuoteSubmissionScreenState();
}

class _QuoteSubmissionScreenState extends State<QuoteSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, double> _prices = {};
  
  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<MockDataService>();
    final rfq = dataService.rfqs.firstWhere((r) => r.id == widget.rfqId);
    
    return Scaffold(
      appBar: AppBar(title: Text('Quote for ${rfq.title}')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: rfq.items.map((rfqItem) {
                    final item = dataService.items.firstWhere((i) => i.id == rfqItem.itemId);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50, height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(image: NetworkImage(item.imageUrl), fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, style: context.textStyles.titleMedium?.bold),
                                      Text('Qty: ${rfqItem.quantity} ${item.unit}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Unit Price',
                                prefixText: '\$ ',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required';
                                if (double.tryParse(v) == null) return 'Invalid number';
                                return null;
                              },
                              onSaved: (v) {
                                _prices[rfqItem.itemId] = double.parse(v!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      
                      // Calculate total
                      double total = 0;
                      List<QuoteItem> quoteItems = [];
                      for (var rfqItem in rfq.items) {
                        final price = _prices[rfqItem.itemId]!;
                        total += price * rfqItem.quantity;
                        quoteItems.add(QuoteItem(
                          itemId: rfqItem.itemId,
                          unitPrice: price,
                          quantity: rfqItem.quantity,
                        ));
                      }
                      
                      context.read<MockDataService>().submitQuotation(widget.rfqId, total, quoteItems);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quote Submitted Successfully!')),
                      );
                      context.go('/supplier');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Submit Quote'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
