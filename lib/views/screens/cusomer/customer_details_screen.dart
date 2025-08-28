import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/customer_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../models/order_model.dart';
import '../../../routes/app_routes.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {@override
void initState() {
  super.initState();
  final orderController = context.read<OrderController>();
  orderController.fetchOrders(widget.customerId);
}


@override
  Widget build(BuildContext context) {
    final customerController = Provider.of<CustomerController>(context);
    final orderController = Provider.of<OrderController>(context);

    final customer = customerController.getCustomerById(widget.customerId);

    if (customer == null) {
      return const Scaffold(
        body: Center(child: Text("Customer not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.addOrder,
                arguments: customer.id,
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Info
            Text(
              customer.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Phone: ${customer.phoneNumber}"),
            Text("DOB: ${customer.dob}"),
            Text("Address: ${customer.address}"),
            Text("Gender: ${customer.gender}"),
            Text("Cloth Type: ${customer.clothType}"),
            const Divider(height: 30),

            // Measurements
            const Text(
              "Measurements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Chest: ${customer.chest} in"),
            Text("Waist: ${customer.waist} in"),
            Text("Length: ${customer.length} in"),
            const Divider(height: 30),

            // Orders
            const Text(
              "Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            orderController.orders.isEmpty
                ? const Text("No orders yet for this customer.")
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderController.orders.length,
              itemBuilder: (context, index) {
                final Order order = orderController.orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text("Order Date: ${order.orderDate.toLocal()}"),
                    subtitle: Text(
                        "Delivery: ${order.deliveryDate.toLocal()}\nStatus: ${order.status}\nNotes: ${order.notes}"),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
