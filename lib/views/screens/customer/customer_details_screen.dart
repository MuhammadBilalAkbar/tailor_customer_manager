// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../controllers/customer_controller.dart';
// import '../../../controllers/order_controller.dart';
// import '../../../models/order_model.dart';
// import '../../../routes/app_routes.dart';
//
// class CustomerDetailsScreen extends StatefulWidget {
//   final String customerId;
//
//   const CustomerDetailsScreen({super.key, required this.customerId});
//
//   @override
//   State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
// }
//
// class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {@override
// void initState() {
//   super.initState();
//   final orderController = context.read<OrderController>();
//   orderController.fetchOrders(widget.customerId);
// }
//
//
// @override
//   Widget build(BuildContext context) {
//     final customerController = Provider.of<CustomerController>(context);
//     final orderController = Provider.of<OrderController>(context);
//
//     final customer = customerController.getCustomerById(widget.customerId);
//
//     if (customer == null) {
//       return const Scaffold(
//         body: Center(child: Text("Customer not found")),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(customer.fullName),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.pushNamed(
//                 context,
//                 AppRoutes.addOrder,
//                 arguments: customer.id,
//               );
//             },
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Customer Info
//             Text(
//               customer.fullName,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("Phone: ${customer.phoneNumber}"),
//             Text("DOB: ${customer.dob}"),
//             Text("Address: ${customer.address}"),
//             Text("Gender: ${customer.gender}"),
//             Text("Cloth Type: ${customer.clothType}"),
//             const Divider(height: 30),
//
//             // Measurements
//             const Text(
//               "Measurements",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text("Chest: ${customer.chest} in"),
//             Text("Waist: ${customer.waist} in"),
//             Text("Length: ${customer.length} in"),
//             const Divider(height: 30),
//
//             // Orders
//             const Text(
//               "Orders",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             orderController.orders.isEmpty
//                 ? const Text("No orders yet for this customer.")
//                 : ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: orderController.orders.length,
//               itemBuilder: (context, index) {
//                 final Order order = orderController.orders[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   child: ListTile(
//                     title: Text("Order Date: ${order.orderDate.toLocal()}"),
//                     subtitle: Text(
//                         "Delivery: ${order.deliveryDate.toLocal()}\nStatus: ${order.status}\nNotes: ${order.notes}"),
//                     isThreeLine: true,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/customer_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../models/order_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants.dart';
import '../../../core/helpers.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final orderCtrl = context.read<OrderController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderCtrl.fetchOrders(widget.customerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerCtrl = context.watch<CustomerController>();
    final orderCtrl = context.watch<OrderController>();

    final customer = customerCtrl.getCustomerById(widget.customerId);
    if (customer == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(title: const Text('Customer')),
        body: const Center(
          child: Text('Customer not found', style: TextStyle(color: AppColors.text)),
        ),
      );
    }

    // Format DOB (stored as ISO string in your model)
    String dobText;
    try {
      dobText = formatDate(DateTime.parse(customer.dob));
    } catch (_) {
      dobText = customer.dob; // fallback to raw if parsing fails
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(customer.fullName),
        actions: [
          IconButton(
            tooltip: 'Add Order',
            icon: const Icon(Icons.add),
            onPressed: () {
              final ctrl = context.read<OrderController>();
              Navigator.pushNamed(
                context,
                AppRoutes.addOrder,
                arguments: customer.id,
              ).then((_) {
                ctrl.fetchOrders(customer.id);
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.pushNamed(
                  context,
                  AppRoutes.editCustomer,
                  arguments: customer,
                );
              } else if (value == 'orders') {
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
              PopupMenuItem(value: 'edit', child: Text('Edit Customer')),
              PopupMenuItem(value: 'orders', child: Text('View All Orders')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Gaps.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Customer info ===
            Text(
              customer.fullName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: Gaps.xs),
            const SizedBox(height: 2),
            Text('Phone: ${customer.phoneNumber}', style: const TextStyle(color: AppColors.text)),
            Text('DOB: $dobText', style: const TextStyle(color: AppColors.text)),
            Text('Address: ${customer.address}', style: const TextStyle(color: AppColors.text)),
            const SizedBox(height: Gaps.sm),
            Wrap(
              spacing: Gaps.xs,
              runSpacing: Gaps.xs,
              children: [
                Chip(
                  label: Text(customer.gender),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                ),
                Chip(
                  label: Text(customer.clothType),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                ),
              ],
            ),
            const SizedBox(height: Gaps.md),
            const Divider(color: AppColors.border, height: Gaps.xl),

            // === Measurements ===
            const Text(
              'Measurements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: Gaps.xs),
            Text('Chest: ${customer.chest} in', style: const TextStyle(color: AppColors.text)),
            Text('Waist: ${customer.waist} in', style: const TextStyle(color: AppColors.text)),
            Text('Length: ${customer.length} in', style: const TextStyle(color: AppColors.text)),
            const SizedBox(height: Gaps.md),
            const Divider(color: AppColors.border, height: Gaps.xl),

            // === Orders ===
            const Text(
              'Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: Gaps.sm),

            if (orderCtrl.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Gaps.md),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (orderCtrl.orders.isEmpty)
              const Text('No orders yet for this customer.', style: TextStyle(color: AppColors.text))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderCtrl.orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: Gaps.xs),
                itemBuilder: (context, index) {
                  final Order o = orderCtrl.orders[index];
                  final orderDate = formatDate(o.orderDate);
                  final deliveryDate = formatDate(o.deliveryDate);
                  final isCompleted = o.status.toLowerCase() == 'completed';

                  final bgColor = isCompleted
                      ? AppColors.completed.withValues(alpha: 0.15)
                      : AppColors.pending.withValues(alpha: 0.15);

                  final labelColor = isCompleted ? AppColors.completed : AppColors.pending;

                  return Card(
                    elevation: 0,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.sm),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: ListTile(
                      title: Text(
                        '$orderDate → $deliveryDate',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.text),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          o.notes.isNotEmpty ? o.notes : 'No notes',
                          style: const TextStyle(color: AppColors.text),
                        ),
                      ),
                      trailing: Chip(
                        label: Text(o.status, style: TextStyle(color: labelColor)),
                        backgroundColor: bgColor,
                        side: BorderSide(color: labelColor.withValues(alpha: 0.35)),
                      ),
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
