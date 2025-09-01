// import 'package:flutter/material.dart';
// import 'custom_text_field.dart';
// import '../../core/validators.dart';
//
// class MeasurementFields extends StatelessWidget {
//   final TextEditingController chest;
//   final TextEditingController waist;
//   final TextEditingController length;
//   final bool requiredFields;
//
//   const MeasurementFields({
//     super.key,
//     required this.chest,
//     required this.waist,
//     required this.length,
//     this.requiredFields = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomTextField(
//           controller: chest,
//           label: 'Chest (inches)',
//           keyboardType: TextInputType.number,
//           validator: requiredFields
//               ? (v) => Validators.numberRequired(v, label: 'Chest (inches)')
//               : Validators.number,
//         ),
//         const SizedBox(height: 12),
//         CustomTextField(
//           controller: waist,
//           label: 'Waist (inches)',
//           keyboardType: TextInputType.number,
//           validator: requiredFields
//               ? (v) => Validators.numberRequired(v, label: 'Waist (inches)')
//               : Validators.number,
//         ),
//         const SizedBox(height: 12),
//         CustomTextField(
//           controller: length,
//           label: 'Length (inches)',
//           keyboardType: TextInputType.number,
//           validator: requiredFields
//               ? (v) => Validators.numberRequired(v, label: 'Length (inches)')
//               : Validators.number,
//         ),
//       ],
//     );
//   }
// }


// lib/views/widgets/measurement_fields.dart
import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import '../../core/validators.dart';
import '../../core/constants.dart';

class MeasurementFields extends StatelessWidget {
  final TextEditingController chest;
  final TextEditingController waist;
  final TextEditingController length;
  final bool requiredFields;

  const MeasurementFields({
    super.key,
    required this.chest,
    required this.waist,
    required this.length,
    this.requiredFields = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chest
        CustomTextField(
          controller: chest,
          label: 'Chest (inches)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          validator: requiredFields
              ? (v) => Validators.numberRequired(v, label: 'Chest (inches)')
              : Validators.number,
        ),
        const SizedBox(height: Gaps.sm),

        // Waist
        CustomTextField(
          controller: waist,
          label: 'Waist (inches)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          validator: requiredFields
              ? (v) => Validators.numberRequired(v, label: 'Waist (inches)')
              : Validators.number,
        ),
        const SizedBox(height: Gaps.sm),

        // Length
        CustomTextField(
          controller: length,
          label: 'Length (inches)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          validator: requiredFields
              ? (v) => Validators.numberRequired(v, label: 'Length (inches)')
              : Validators.number,
        ),
      ],
    );
  }
}
