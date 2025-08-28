import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/validators.dart';
import '../../../../core/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: passwordController,
                label: 'Password',
                obscure: true,
                validator: Validators.password,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Login',
                isLoading: authController.isLoading,
                onPressed: () async {
                  hideKeyboard(context);
                  if (!formKey.currentState!.validate()) return;

                  final ok = await authController.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  if (!context.mounted) return;
                  if (ok) {
                    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                  } else {
                    showSnack(
                      context,
                      authController.lastError ?? 'Login Failed',
                      success: false,
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Continue with Google'),
                onPressed: authController.isLoading
                    ? null
                    : () async {
                  final ok =
                  await context.read<AuthController>().loginWithGoogle();
                  if (!context.mounted) return;
                  if (ok) {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.dashboard);
                  } else {
                    showSnack(context, 'Google sign-in failed',
                        success: false);
                  }
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.signup,
                            (_) => false,
                      );
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
