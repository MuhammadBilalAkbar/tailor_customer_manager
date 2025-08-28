import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final auth = context.read<AuthController>();
    final navigator = Navigator.of(context);

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email == null || password == null) {
      if (!mounted) return;
      navigator.pushReplacementNamed(AppRoutes.login);
      setState(() => _isChecking = false);
      return;
    }

    final success = await auth.login(email, password);

    if (!mounted) return;

    navigator.pushReplacementNamed(
      success ? AppRoutes.dashboard : AppRoutes.login,
    );
    setState(() => _isChecking = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isChecking
            ? const CircularProgressIndicator()
            : const Text("Redirecting..."),
      ),
    );
  }
}
