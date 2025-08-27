import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authController.isLoading
                  ? null
                  : () async {
                final success = await authController.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                if (success && mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed")));
                }
              },
              child: authController.isLoading ? const CircularProgressIndicator() : const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.signup);
              },
              child: const Text("Don’t have an account? Sign up"),
            )
          ],
        ),
      ),
    );
  }
}
