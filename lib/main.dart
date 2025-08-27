import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/customer_controller.dart';
import 'controllers/order_controller.dart';
import 'routes/app_routes.dart';
import 'views/screens/auth/login_screen.dart';
import 'views/screens/auth/signup_screen.dart';
import 'views/screens/cusomer/add_customer_screen.dart';
import 'views/screens/cusomer/customer_details_screen.dart';
import 'views/screens/cusomer/customer_list_screen.dart';
import 'views/screens/dashboard_screen.dart';
import 'views/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => CustomerController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
      ],
      child: MaterialApp(
        title: 'Tailor Customer Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const HomeScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.signup: (context) => const SignupScreen(),
            AppRoutes.dashboard: (context) => const DashboardScreen(),
            AppRoutes.customerList: (context) => const CustomerListScreen(),
            AppRoutes.customerDetails: (context) {
              final customerId = ModalRoute.of(context)!.settings.arguments as String;
              return CustomerDetailsScreen(customerId: customerId);
            },
            AppRoutes.addCustomer: (context) => const AddCustomerScreen(),
            AppRoutes.addOrder: (context) {
              final customerId = ModalRoute.of(context)!.settings.arguments as String;
              return AddOrderScreen(customerId: customerId);
            },
          }

      ),
    );
  }
}
