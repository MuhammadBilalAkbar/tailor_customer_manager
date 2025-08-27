import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
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
                final success = await authController.signUp(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                if (success && mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signup Failed")));
                }
              },
              child: authController.isLoading ? const CircularProgressIndicator() : const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
