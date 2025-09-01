// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String? hint;
//   final bool obscure;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   final TextInputAction textInputAction;
//   final int maxLines;
//
//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.hint,
//     this.obscure = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//     this.textInputAction = TextInputAction.next,
//     this.maxLines = 1,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscure,
//       keyboardType: keyboardType,
//       validator: validator,
//       textInputAction: textInputAction,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         border: const OutlineInputBorder(),
//         isDense: true,
//       ),
//     );
//   }
// }


// lib/views/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      maxLines: maxLines,
      autocorrect: !obscure,
      enableSuggestions: !obscure,
      cursorColor: AppColors.primary,
      style: const TextStyle(color: AppColors.text),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Gaps.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
        ),
      ),
    );
  }
}
