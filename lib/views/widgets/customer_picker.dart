// lib/views/widgets/customer_picker.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/customer_controller.dart';
import '../../models/customer_model.dart';
import '../../routes/app_routes.dart';

class CustomerPicker {
  static Future<Customer?> show(BuildContext context) async {
    final customerCtrl = context.read<CustomerController>();

    if (customerCtrl.customers.isEmpty && !customerCtrl.isLoading) {
      await customerCtrl.fetchCustomers();
    }
    if (!context.mounted) return null;

    final rootContext = context;

    return showModalBottomSheet<Customer>(
      context: rootContext,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetCtx) {
        String query = '';
        final searchCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (innerCtx, setState) {
            final customers = innerCtx.watch<CustomerController>().customers;
            final isLoading = innerCtx.watch<CustomerController>().isLoading;

            final filtered = customers.where((c) {
              if (query.isEmpty) return true;
              final q = query.toLowerCase();
              return c.fullName.toLowerCase().contains(q) ||
                  c.phoneNumber.toLowerCase().contains(q) ||
                  c.clothType.toLowerCase().contains(q);
            }).toList();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(innerCtx).viewInsets.bottom + 16,
                  top: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Customer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: '🔍 Search or Filter',
                        // hintText: 'Search by name or phone',
                        // helperText: '• Filter by cloth type\n• Filter by order status', helperMaxLines: 2,
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (v) => setState(() => query = v.trim()),
                    ),
                    const SizedBox(height: 10),

                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            const Text('No customers found.'),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              icon: const Icon(Icons.person_add),
                              label: const Text('Add Customer'),
                              onPressed: () {
                                Navigator.pop(sheetCtx);
                                Future.microtask(() {
                                  if (rootContext.mounted) {
                                    Navigator.of(rootContext).pushNamed(AppRoutes.addCustomer);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (itemCtx, i) {
                            final c = filtered[i];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(c.fullName[0].toUpperCase()),
                              ),
                              title: Text(c.fullName),
                              subtitle: Text('${c.phoneNumber} • ${c.clothType}'),
                              onTap: () => Navigator.pop(sheetCtx, c),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
