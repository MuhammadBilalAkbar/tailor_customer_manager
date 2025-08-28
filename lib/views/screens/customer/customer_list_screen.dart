import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/customer_controller.dart';
import '../../../routes/app_routes.dart';

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
    final customerController = Provider.of<CustomerController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addCustomer);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Customer'),
            ),
          ),
        ],
      ),
      body: customerController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : customerController.customers.isEmpty
          ? const Center(child: Text("No customers found."))
          : ListView.builder(
        itemCount: customerController.customers.length,
        itemBuilder: (context, index) {
          final customer = customerController.customers[index];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(customer.fullName[0].toUpperCase()),
              ),
              title: Text(customer.fullName),
              subtitle: Text(
                "${customer.phoneNumber} • ${customer.clothType}",
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
                        const SnackBar(content: Text("Customer deleted")),
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
