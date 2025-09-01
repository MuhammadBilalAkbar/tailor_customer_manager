// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../controllers/auth_controller.dart';
// import '../../routes/app_routes.dart';
// import '../widgets/customer_picker.dart';
//
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authController = Provider.of<AuthController>(context, listen: false);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Tailor Dashboard"),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: TextButton.icon(
//               onPressed: () async {
//                 await authController.logout();
//                 if (context.mounted) {
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     AppRoutes.login,
//                         (_) => false,
//                   );
//                 }
//               },
//               icon: const Icon(Icons.logout),
//               label: const Text('Logout'),
//             ),
//           ),
//         ],
//       ),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(20),
//         crossAxisSpacing: 15,
//         mainAxisSpacing: 15,
//         children: [
//           _DashboardCard(
//             title: "Customers",
//             icon: Icons.people,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.customerList),
//           ),
//           _DashboardCard(
//             title: "Add Customer",
//             icon: Icons.person_add,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.addCustomer),
//           ),
//           _DashboardCard(
//             title: "Orders",
//             icon: Icons.shopping_bag,
//             onTap: () => _pickCustomerAndGoToOrders(context),
//           ),
//           _DashboardCard(
//             title: "Add Order",
//             icon: Icons.add_shopping_cart,
//             onTap: () => _pickCustomerAndGoToAddOrder(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Choose a customer then open per-customer Orders
//   Future<void> _pickCustomerAndGoToOrders(BuildContext context) async {
//     final navigator = Navigator.of(context); // capture before async
//     final selected = await CustomerPicker.show(context);
//     if (selected == null || !context.mounted) return;
//     navigator.pushNamed(
//       AppRoutes.customerOrders,
//       arguments: {
//         'customerId': selected.id,
//         'customerName': selected.fullName,
//       },
//     );
//   }
//
//   /// Choose a customer then open Add Order (needs customerId)
//   Future<void> _pickCustomerAndGoToAddOrder(BuildContext context) async {
//     final navigator = Navigator.of(context); // capture before async
//     final selected = await CustomerPicker.show(context);
//     if (selected == null || !context.mounted) return;
//     navigator.pushNamed(AppRoutes.addOrder, arguments: selected.id);
//   }
// }
//
// class _DashboardCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onTap;
//
//   const _DashboardCard({
//     required this.title,
//     required this.icon,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         elevation: 4,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 50, color: Theme.of(context).primaryColor),
//               const SizedBox(height: 10),
//               Text(title, style: const TextStyle(fontSize: 16)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// lib/views/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../core/constants.dart';
import '../widgets/customer_picker.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final theme = Theme.of(context);

    // Same approach as Customer List: pick a readable color for AppBar actions
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
        title: const Text('Tailor Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Gaps.sm),
            child: TextButton.icon(
              onPressed: () async {
                final navigator = Navigator.of(context); // capture before await
                await authController.logout();
                if (!context.mounted) return;
                navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
              },
              icon: Icon(Icons.logout, color: actionFg),
              label: Text('Logout', style: TextStyle(color: actionFg)),
              style: TextButton.styleFrom(
                foregroundColor: actionFg, // ensures ripple/overlay is correct too
              ),
            ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(Gaps.lg),
        crossAxisSpacing: Gaps.sm,
        mainAxisSpacing: Gaps.sm,
        children: [
          _DashboardCard(
            title: 'Customers',
            icon: Icons.people,
            onTap: () => Navigator.pushNamed(context, AppRoutes.customerList),
          ),
          _DashboardCard(
            title: 'Add Customer',
            icon: Icons.person_add,
            onTap: () => Navigator.pushNamed(context, AppRoutes.addCustomer),
          ),
          _DashboardCard(
            title: 'Orders',
            icon: Icons.shopping_bag,
            onTap: () => _pickCustomerAndGoToOrders(context),
          ),
          _DashboardCard(
            title: 'Add Order',
            icon: Icons.add_shopping_cart,
            onTap: () => _pickCustomerAndGoToAddOrder(context),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomerAndGoToOrders(BuildContext context) async {
    final navigator = Navigator.of(context); // capture before async
    final selected = await CustomerPicker.show(context);
    if (selected == null || !context.mounted) return;
    navigator.pushNamed(
      AppRoutes.customerOrders,
      arguments: {
        'customerId': selected.id,
        'customerName': selected.fullName,
      },
    );
  }

  Future<void> _pickCustomerAndGoToAddOrder(BuildContext context) async {
    final navigator = Navigator.of(context); // capture before async
    final selected = await CustomerPicker.show(context);
    if (selected == null || !context.mounted) return;
    navigator.pushNamed(AppRoutes.addOrder, arguments: selected.id);
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.md),
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Gaps.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 48, color: AppColors.primary),
                const SizedBox(height: Gaps.sm),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: AppColors.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
