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

  // local saving flag for overlay spinner
  bool _saving = false;

  Future<void> _pickDate({required bool isOrderDate}) async {
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
      body: Stack(
        children: [
          Padding(
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
                      icon: _saving
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.save),
                      label: Text(_saving ? 'Saving...' : 'Save Order'),
                      onPressed: _saving
                          ? null
                          : () async {
                        // Basic validation: delivery >= order date
                        if (_deliveryDate.isBefore(_orderDate)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Delivery date cannot be before order date'),
                            ),
                          );
                          return;
                        }

                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);

                        final order = Order(
                          id: '',
                          customerId: widget.customerId,
                          orderDate: _orderDate,
                          deliveryDate: _deliveryDate,
                          status: _status,
                          notes: _notesCtrl.text.trim(),
                        );

                        setState(() => _saving = true);

                        bool ok;
                        try {
                          await orderController.addOrder(order);
                          ok = true;
                        } catch (_) {
                          ok = false;
                        }

                        if (!mounted) return;
                        setState(() => _saving = false);

                        if (ok) {
                          messenger.hideCurrentSnackBar();
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Order added')),
                          );
                          navigator.pop();
                        } else {
                          messenger.hideCurrentSnackBar();
                          messenger.showSnackBar(
                            const SnackBar(
                                content: Text('Failed to add order')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Full-screen overlay while saving
          if (_saving) ...[
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withValues(alpha: 0.05),
            ),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
