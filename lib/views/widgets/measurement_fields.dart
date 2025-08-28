import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import '../../core/validators.dart';

class MeasurementFields extends StatelessWidget {
  final TextEditingController chest;
  final TextEditingController waist;
  final TextEditingController length;

  const MeasurementFields({
    super.key,
    required this.chest,
    required this.waist,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: chest,
          label: 'Chest (inches)',
          keyboardType: TextInputType.number,
          validator: Validators.number,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: waist,
          label: 'Waist (inches)',
          keyboardType: TextInputType.number,
          validator: Validators.number,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: length,
          label: 'Length (inches)',
          keyboardType: TextInputType.number,
          validator: Validators.number,
        ),
      ],
    );
  }
}
