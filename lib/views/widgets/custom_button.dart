// import 'package:flutter/material.dart';
//
// class PrimaryButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final bool isLoading;
//
//   const PrimaryButton({
//     super.key,
//     required this.text,
//     this.onPressed,
//     this.isLoading = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         child: isLoading
//             ? const SizedBox(
//             height: 22, width: 22, child: CircularProgressIndicator())
//             : Text(text),
//       ),
//     );
//   }
// }


// lib/views/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
          ),
        ),
        child: AnimatedSwitcher(
          duration: Times.fast,
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isLoading
              ? SizedBox(
            key: const ValueKey('loading'),
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              // use onPrimary to keep spinner visible on the button color
              valueColor: AlwaysStoppedAnimation<Color>(onPrimary),
            ),
          )
              : Text(
            text,
            key: const ValueKey('label'),
            style: TextStyle(
              color: onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
