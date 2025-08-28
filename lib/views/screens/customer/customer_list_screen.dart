// lib/views/screens/customer/customer_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/customer_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants.dart'; // ← use AppColors, Gaps, AppLists

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  @override
  void initState() {
    super.initState();

    final customerController = context.read<CustomerController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      customerController.fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerController = context.watch<CustomerController>();

    // Ensure button text is visible on the AppBar background
    final onAppBarColor =
        Theme.of(context).appBarTheme.foregroundColor ??
            Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Gaps.sm),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addCustomer);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Customer'),
              style: TextButton.styleFrom(
                foregroundColor: onAppBarColor,
              ),
            ),
          ),
        ],
      ),
      body: customerController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : customerController.customers.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(Gaps.lg),
          child: Text(
            "No customers found.",
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: Gaps.md,
          vertical: Gaps.sm,
        ),
        itemCount: customerController.customers.length,
        itemBuilder: (context, index) {
          final customer = customerController.customers[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: Gaps.xs,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Gaps.md,
                vertical: Gaps.xs,
              ),
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  customer.fullName[0].toUpperCase(),
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
              title: Text(
                customer.fullName,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: Gaps.xxs),
                child: Text(
                  "${customer.phoneNumber} • ${customer.clothType}",
                  style: const TextStyle(color: AppColors.text),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.customerDetails,
                  arguments: customer.id,
                );
              },
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == "edit") {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editCustomer,
                      arguments: customer, // pass the object
                    );
                  } else if (value == "delete") {
                    await customerController.deleteCustomer(customer.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Customer deleted"),
                          backgroundColor: AppColors.danger,
                        ),
                      );
                    }
                  } else if (value == "orders") {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.customerOrders,
                      arguments: {
                        'customerId': customer.id,
                        'customerName': customer.fullName,
                      },
                    );
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: "edit",
                    child: Text("Edit"),
                  ),
                  PopupMenuItem(
                    value: "delete",
                    child: Text("Delete"),
                  ),
                  PopupMenuItem(
                    value: "orders",
                    child: Text("View Orders"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
