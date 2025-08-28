import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/order_controller.dart';
import '../../../models/order_model.dart';

class AddOrderScreen extends StatefulWidget {
  final String customerId;

  const AddOrderScreen({super.key, required this.customerId});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _orderDate = DateTime.now();
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 7));
  String _status = 'Pending';
  final TextEditingController _notesCtrl = TextEditingController();

  Future<void> _pickDate({
    required bool isOrderDate,
  }) async {
    final initial = isOrderDate ? _orderDate : _deliveryDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isOrderDate) {
          _orderDate = picked;
          if (_deliveryDate.isBefore(_orderDate)) {
            _deliveryDate = _orderDate;
          }
        } else {
          _deliveryDate = picked;
        }
      });
    }
  }

  String _fmt(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderController = Provider.of<OrderController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Order')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Order Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Order Date'),
                subtitle: Text(_fmt(_orderDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () => _pickDate(isOrderDate: true),
                ),
              ),
              const SizedBox(height: 8),

              // Delivery Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Delivery Date'),
                subtitle: Text(_fmt(_deliveryDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () => _pickDate(isOrderDate: false),
                ),
              ),
              const SizedBox(height: 12),

              // Status
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'Pending'),
              ),
              const SizedBox(height: 12),

              // Notes
              TextFormField(
                controller: _notesCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Add any special instructions or details…',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Save
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Order'),
                  onPressed: () async {
                    // Basic validation: delivery >= order date
                    if (_deliveryDate.isBefore(_orderDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delivery date cannot be before order date'),
                        ),
                      );
                      return;
                    }

                    final order = Order(
                      id: '',
                      customerId: widget.customerId,
                      orderDate: _orderDate,
                      deliveryDate: _deliveryDate,
                      status: _status,
                      notes: _notesCtrl.text.trim(),
                    );

                    await orderController.addOrder(order);

                    if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order added')),
                      );
                      Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
