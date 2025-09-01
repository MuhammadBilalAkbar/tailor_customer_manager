// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../controllers/auth_controller.dart';
// import '../../../../routes/app_routes.dart';
// import '../../../../core/validators.dart';
// import '../../../../core/helpers.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_text_field.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _showPostSignupChoice(BuildContext context) async {
//     // let the user choose to go back to Login or forward to Dashboard
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Account created'),
//         content: const Text('Where would you like to go next?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop(); // close dialog
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                 AppRoutes.login,
//                     (_) => false,
//               );
//             },
//             child: const Text('Back to Login'),
//           ),
//           FilledButton(
//             onPressed: () {
//               Navigator.of(ctx).pop(); // close dialog
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                 AppRoutes.dashboard,
//                     (_) => false,
//               );
//             },
//             child: const Text('Go to Dashboard'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authController = Provider.of<AuthController>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Sign Up")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: formKey,
//           child: ListView(
//             children: [
//               CustomTextField(
//                 controller: emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//                 validator: Validators.email,
//               ),
//               const SizedBox(height: 12),
//               CustomTextField(
//                 controller: passwordController,
//                 label: 'Password',
//                 obscure: true,
//                 validator: Validators.password,
//               ),
//               const SizedBox(height: 20),
//
//               // Sign Up
//               PrimaryButton(
//                 text: 'Sign Up',
//                 isLoading: authController.isLoading,
//                 onPressed: () async {
//                   hideKeyboard(context);
//                   if (!formKey.currentState!.validate()) return;
//
//                   final ok = await authController.signUp(
//                     emailController.text.trim(),
//                     passwordController.text.trim(),
//                   );
//
//                   if (!context.mounted) return;
//
//                   if (ok) {
//                     showSnack(context, 'Account created');
//                     await _showPostSignupChoice(context); // 👈 give the choice
//                   } else {
//                     showSnack(
//                       context,
//                       authController.lastError ?? 'Signup Failed',
//                       success: false,
//                     );
//                   }
//                 },
//               ),
//
//               const SizedBox(height: 12),
//
//               // Google (kept as-is per your request)
//               OutlinedButton.icon(
//                 icon: const Icon(Icons.login),
//                 label: const Text('Continue with Google'),
//                 onPressed: authController.isLoading
//                     ? null
//                     : () async {
//                   final ok = await context.read<AuthController>().loginWithGoogle();
//                   if (!context.mounted) return;
//                   if (ok) {
//                     Navigator.pushNamedAndRemoveUntil(
//                       context,
//                       AppRoutes.dashboard,
//                           (_) => false,
//                     );
//                   } else {
//                     showSnack(context, 'Google sign-in failed', success: false);
//                   }
//                 },
//               ),
//
//               const SizedBox(height: 16),
//
//               // Also provide a manual way back to Login
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Already have an account?"),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamedAndRemoveUntil(
//                         context,
//                         AppRoutes.login,
//                             (_) => false,
//                       );
//                     },
//                     child: const Text('Log in'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/validators.dart';
import '../../../../core/helpers.dart';
import '../../../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _showPostSignupChoice(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Account created'),
        content: const Text('Where would you like to go next?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                    (_) => false,
              );
            },
            child: const Text('Back to Login'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.dashboard,
                    (_) => false,
              );
            },
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }

  Future<void> _doEmailSignup() async {
    hideKeyboard(context);
    if (!formKey.currentState!.validate()) return;

    final ok = await context.read<AuthController>().signUp(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;
    if (ok) {
      showSnack(context, 'Account created');
      await _showPostSignupChoice(context);
      // or navigate here with: navigator.pushNamedAndRemoveUntil(...);
    } else {
      showSnack(
        context,
        context.read<AuthController>().lastError ?? 'Signup Failed',
        success: false,
      );
    }
  }

  Future<void> _doGoogleSignup() async {
    final navigator = Navigator.of(context); // capture before async gap
    final ok = await context.read<AuthController>().loginWithGoogle();

    if (!mounted) return;
    if (ok) {
      navigator.pushNamedAndRemoveUntil(AppRoutes.dashboard, (_) => false);
    } else {
      showSnack(context, 'Google sign-in failed', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // hide back arrow on signup
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Gaps.md),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: Gaps.sm),
              CustomTextField(
                controller: passwordController,
                label: 'Password',
                obscure: true,
                validator: Validators.password,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: Gaps.lg),

              // Sign Up
              PrimaryButton(
                text: 'Sign Up',
                isLoading: authController.isLoading,
                onPressed: authController.isLoading ? null : _doEmailSignup,
              ),

              const SizedBox(height: Gaps.sm),

              // Google (kept per your request)
              OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Continue with Google'),
                onPressed: authController.isLoading ? null : _doGoogleSignup,
              ),

              const SizedBox(height: Gaps.md),

              // Manual way back to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                            (_) => false,
                      );
                    },
                    child: const Text('Log in'),
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
