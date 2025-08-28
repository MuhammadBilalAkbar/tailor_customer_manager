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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addCustomer);
            },
          )
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
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
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
                      AppRoutes.addCustomer, // Or AppRoutes.editCustomer
                      arguments: customer, // Pass full object
                    );
                  } else if (value == "delete") {
                    await customerController.deleteCustomer(customer.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Customer deleted")),
                      );
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "edit",
                    child: Text("Edit"),
                  ),
                  const PopupMenuItem(
                    value: "delete",
                    child: Text("Delete"),
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
