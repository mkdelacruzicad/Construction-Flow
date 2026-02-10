import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/mock_data_service.dart';
import '../../models/data_models.dart';
import '../../theme.dart';
import 'package:intl/intl.dart';

class CreateRFQScreen extends StatefulWidget {
  const CreateRFQScreen({super.key});

  @override
  _CreateRFQScreenState createState() => _CreateRFQScreenState();
}

class _CreateRFQScreenState extends State<CreateRFQScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _projectId = '';
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  final List<RFQItem> _selectedItems = [];

  void _addItem() async {
    final item = await showDialog<Item>(
      context: context,
      builder: (context) => const _ItemSelectionDialog(),
    );

    if (item != null) {
      final quantity = await showDialog<double>(
        context: context,
        builder: (context) => _QuantityDialog(item: item),
      );

      if (quantity != null) {
        setState(() {
          _selectedItems.add(RFQItem(itemId: item.id, quantity: quantity));
        });
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one item')),
        );
        return;
      }
      
      context.read<MockDataService>().createRFQ(_title, _projectId, _deadline, _selectedItems);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RFQ Created Successfully')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New RFQ')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'RFQ Title'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                      onSaved: (v) => _title = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Project ID'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                      onSaved: (v) => _projectId = v!,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Deadline'),
                      subtitle: Text(DateFormat('yyyy-MM-dd').format(_deadline)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _deadline,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) setState(() => _deadline = picked);
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Items', style: context.textStyles.titleMedium),
                        IconButton(icon: const Icon(Icons.add_circle), onPressed: _addItem),
                      ],
                    ),
                    const Divider(),
                    if (_selectedItems.isEmpty)
                      const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No items added. Tap + to add.'),
                      ))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _selectedItems.length,
                        itemBuilder: (context, index) {
                          final rfqItem = _selectedItems[index];
                          final item = context.read<MockDataService>().items.firstWhere((i) => i.id == rfqItem.itemId);
                          return ListTile(
                            leading: CircleAvatar(backgroundImage: NetworkImage(item.imageUrl)),
                            title: Text(item.name),
                            subtitle: Text('${rfqItem.quantity} ${item.unit}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => setState(() => _selectedItems.removeAt(index)),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Publish RFQ'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemSelectionDialog extends StatelessWidget {
  const _ItemSelectionDialog();

  @override
  Widget build(BuildContext context) {
    final items = context.watch<MockDataService>().items;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 400,
        child: Column(
          children: [
            Text('Select Item', style: context.textStyles.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.code),
                    onTap: () => Navigator.pop(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityDialog extends StatefulWidget {
  final Item item;
  const _QuantityDialog({required this.item});

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<_QuantityDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Quantity for ${widget.item.name}'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(suffixText: widget.item.unit),
        autofocus: true,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final val = double.tryParse(_controller.text);
            if (val != null && val > 0) Navigator.pop(context, val);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
