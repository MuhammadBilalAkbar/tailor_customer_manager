// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../controllers/auth_controller.dart';
// import '../../routes/app_routes.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   bool _isChecking = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLogin();
//   }
//
//   Future<void> _checkLogin() async {
//     final auth = context.read<AuthController>();
//     final navigator = Navigator.of(context);
//
//     final prefs = await SharedPreferences.getInstance();
//     final email = prefs.getString('email');
//     final password = prefs.getString('password');
//
//     if (email == null || password == null) {
//       if (!mounted) return;
//       navigator.pushReplacementNamed(AppRoutes.login);
//       setState(() => _isChecking = false);
//       return;
//     }
//
//     final success = await auth.login(email, password);
//
//     if (!mounted) return;
//
//     navigator.pushReplacementNamed(
//       success ? AppRoutes.dashboard : AppRoutes.login,
//     );
//     setState(() => _isChecking = false);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _isChecking
//             ? const CircularProgressIndicator()
//             : const Text("Redirecting..."),
//       ),
//     );
//   }
// }


// lib/views/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../core/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isChecking = true;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  // Defer navigation to the next frame to avoid setState/markNeedsBuild during build.
  void _go(String route) {
    if (_navigated) return;
    _navigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  Future<void> _checkLogin() async {
    final auth = context.read<AuthController>();

    try {
      // 1) Already signed in? Go straight to dashboard.
      final current = FirebaseAuth.instance.currentUser;
      if (current != null) {
        _go(AppRoutes.dashboard);
        return;
      }

      // 2) Try saved credentials
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      final password = prefs.getString('password');

      if (email == null || email.isEmpty || password == null || password.isEmpty) {
        _go(AppRoutes.login);
        return;
      }

      // 3) Attempt login with a timeout (prevents hanging forever)
      bool success = false;
      try {
        success = await auth.login(email, password).timeout(const Duration(seconds: 10));
      } catch (_) {
        success = false;
      }

      _go(success ? AppRoutes.dashboard : AppRoutes.login);
    } finally {
      // Only stop the spinner if we did NOT navigate away.
      if (mounted && !_navigated) {
        setState(() => _isChecking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: _isChecking
            ? const CircularProgressIndicator()
            : const Text(
          'Redirecting...',
          style: TextStyle(color: AppColors.text),
        ),
      ),
    );
  }
}
