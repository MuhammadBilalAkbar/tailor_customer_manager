// // lib/views/screens/customer/customer_list_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../controllers/customer_controller.dart';
// import '../../../routes/app_routes.dart';
// import '../../../core/constants.dart'; // ← use AppColors, Gaps, AppLists
//
// class CustomerListScreen extends StatefulWidget {
//   const CustomerListScreen({super.key});
//
//   @override
//   State<CustomerListScreen> createState() => _CustomerListScreenState();
// }
//
// class _CustomerListScreenState extends State<CustomerListScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     final customerController = context.read<CustomerController>();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       customerController.fetchCustomers();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final customerController = context.watch<CustomerController>();
//
//     // Ensure button text is visible on the AppBar background
//     final onAppBarColor =
//         Theme.of(context).appBarTheme.foregroundColor ??
//             Theme.of(context).colorScheme.onPrimary;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Customers"),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: Gaps.sm),
//             child: TextButton.icon(
//               onPressed: () {
//                 Navigator.pushNamed(context, AppRoutes.addCustomer);
//               },
//               icon: const Icon(Icons.add),
//               label: const Text('Add Customer'),
//               style: TextButton.styleFrom(
//                 foregroundColor: onAppBarColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: customerController.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : customerController.customers.isEmpty
//           ? Center(
//         child: Padding(
//           padding: const EdgeInsets.all(Gaps.lg),
//           child: Text(
//             "No customers found.",
//             style: const TextStyle(
//               color: AppColors.text,
//               fontSize: 16,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       )
//           : ListView.builder(
//         padding: const EdgeInsets.symmetric(
//           horizontal: Gaps.md,
//           vertical: Gaps.sm,
//         ),
//         itemCount: customerController.customers.length,
//         itemBuilder: (context, index) {
//           final customer = customerController.customers[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(
//               horizontal: 0,
//               vertical: Gaps.xs,
//             ),
//             child: ListTile(
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: Gaps.md,
//                 vertical: Gaps.xs,
//               ),
//               leading: CircleAvatar(
//                 backgroundColor: AppColors.primary.withValues(alpha: 0.1),
//                 child: Text(
//                   customer.fullName[0].toUpperCase(),
//                   style: const TextStyle(color: AppColors.primary),
//                 ),
//               ),
//               title: Text(
//                 customer.fullName,
//                 style: const TextStyle(
//                   color: AppColors.text,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               subtitle: Padding(
//                 padding: const EdgeInsets.only(top: Gaps.xxs),
//                 child: Text(
//                   "${customer.phoneNumber} • ${customer.clothType}",
//                   style: const TextStyle(color: AppColors.text),
//                 ),
//               ),
//               onTap: () {
//                 Navigator.pushNamed(
//                   context,
//                   AppRoutes.customerDetails,
//                   arguments: customer.id,
//                 );
//               },
//               trailing: PopupMenuButton<String>(
//                 onSelected: (value) async {
//                   if (value == "edit") {
//                     Navigator.pushNamed(
//                       context,
//                       AppRoutes.editCustomer,
//                       arguments: customer, // pass the object
//                     );
//                   } else if (value == "delete") {
//                     await customerController.deleteCustomer(customer.id);
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Customer deleted"),
//                           backgroundColor: AppColors.danger,
//                         ),
//                       );
//                     }
//                   } else if (value == "orders") {
//                     Navigator.pushNamed(
//                       context,
//                       AppRoutes.customerOrders,
//                       arguments: {
//                         'customerId': customer.id,
//                         'customerName': customer.fullName,
//                       },
//                     );
//                   }
//                 },
//                 itemBuilder: (context) => const [
//                   PopupMenuItem(
//                     value: "edit",
//                     child: Text("Edit"),
//                   ),
//                   PopupMenuItem(
//                     value: "delete",
//                     child: Text("Delete"),
//                   ),
//                   PopupMenuItem(
//                     value: "orders",
//                     child: Text("View Orders"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// lib/views/screens/customer/customer_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/customer_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants.dart';

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

  Future<void> _confirmAndDelete(
      BuildContext context,
      CustomerController ctrl,
      String customerId,
      ) async {
    // Capture messenger BEFORE any await (safe across async gap)
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete customer?'),
        content: const Text(
          'This will permanently remove the customer and their data.\n'
              'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final success = await ctrl.deleteCustomer(customerId);
    if (!context.mounted) return;

    // Use captured messenger (no context misuse after await)
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Customer deleted'
              : (ctrl.lastError ?? 'Failed to delete customer'),
        ),
        backgroundColor: success ? AppColors.success : AppColors.danger,
        behavior: SnackBarBehavior.floating,
        duration: Times.snack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CustomerController>();
    final customers = ctrl.customers;

    // ✅ Robust action color: prefer explicit AppBar foregroundColor,
    // else choose contrast based on whether AppBar uses primary or surface.
    final theme = Theme.of(context);
// Prefer explicit AppBar foregroundColor if set,
// otherwise choose contrast based on whether AppBar uses primary or surface.
    final Color actionFg = theme.appBarTheme.foregroundColor ??
        (() {
          final bg = theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
          final usesPrimaryBg = (bg == theme.colorScheme.primary);
          return usesPrimaryBg
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface;
        }());

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Gaps.sm),
            child: TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.addCustomer),
              icon: Icon(Icons.add, color: actionFg),
              label: Text('Add Customer', style: TextStyle(color: actionFg)),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (customers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Gaps.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline,
                        size: 56, color: AppColors.disabled),
                    const SizedBox(height: Gaps.sm),
                    const Text(
                      'No customers found.',
                      style: TextStyle(color: AppColors.text, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Gaps.sm),
                    TextButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add your first customer'),
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.addCustomer),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<CustomerController>().fetchCustomers(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  Gaps.md, Gaps.sm, Gaps.md, Gaps.lg),
              itemCount: customers.length,
              separatorBuilder: (_, __) => const SizedBox(height: Gaps.xs),
              itemBuilder: (context, i) {
                final c = customers[i];

                return Card(
                  elevation: 0,
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Gaps.md,
                      vertical: Gaps.xs,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.customerDetails,
                        arguments: c.id,
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor:
                      AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        c.fullName.isNotEmpty
                            ? c.fullName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                    title: Text(
                      c.fullName,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: Gaps.xxs),
                      child: Text(
                        '${c.phoneNumber} • ${c.clothType}',
                        style: const TextStyle(color: AppColors.text),
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.editCustomer,
                            arguments: c,
                          );
                        } else if (value == 'orders') {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.customerOrders,
                            arguments: {
                              'customerId': c.id,
                              'customerName': c.fullName,
                            },
                          );
                        } else if (value == 'delete') {
                          await _confirmAndDelete(context, ctrl, c.id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'orders',
                          child: Text('View Orders'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
