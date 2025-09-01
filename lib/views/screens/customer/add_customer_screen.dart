// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../controllers/customer_controller.dart';
// import '../../../../models/customer_model.dart';
// import '../../../../core/constants.dart';
// import '../../../../core/helpers.dart';
// import '../../../../core/validators.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/measurement_fields.dart';
//
// class AddCustomerScreen extends StatefulWidget {
//   const AddCustomerScreen({super.key});
//
//   @override
//   State<AddCustomerScreen> createState() => _AddCustomerScreenState();
// }
//
// class _AddCustomerScreenState extends State<AddCustomerScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final fullNameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();
//   final chestController = TextEditingController();
//   final waistController = TextEditingController();
//   final lengthController = TextEditingController();
//
//   String? _gender;
//   String? _clothType;
//   DateTime? _dob;
//
//   @override
//   void dispose() {
//     fullNameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     chestController.dispose();
//     waistController.dispose();
//     lengthController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final customerController = Provider.of<CustomerController>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add New Customer")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           autovalidateMode: AutovalidateMode.disabled,
//           child: ListView(
//             children: [
//               // Full Name (required)
//               CustomTextField(
//                 controller: fullNameController,
//                 label: 'Full Name',
//                 validator: (v) => Validators.requiredField(v, label: 'Full Name'),
//               ),
//               const SizedBox(height: 12),
//
//               // Phone (required)
//               CustomTextField(
//                 controller: phoneController,
//                 label: 'Phone Number',
//                 keyboardType: TextInputType.phone,
//                 validator: Validators.phone,
//               ),
//               const SizedBox(height: 12),
//
//               // DOB (required) - inline error via FormField
//               FormField<DateTime>(
//                 validator: (_) =>
//                 _dob == null ? 'Please select Date of Birth' : null,
//                 builder: (state) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         title: Text(
//                           _dob == null
//                               ? "Date of Birth: Not selected"
//                               : "DOB: ${formatDate(_dob!)}",
//                         ),
//                         trailing: ElevatedButton(
//                           onPressed: () async {
//                             final picked = await pickDate(context, initial: _dob);
//                             if (picked != null) {
//                               setState(() {
//                                 _dob = picked;
//                                 state.didChange(picked); // inform the FormField
//                               });
//                             }
//                           },
//                           child: const Text("Pick Date"),
//                         ),
//                       ),
//                       if (state.hasError)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4.0, left: 12.0),
//                           child: Text(
//                             state.errorText!,
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.error,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 12),
//
//               // Address (required)
//               CustomTextField(
//                 controller: addressController,
//                 label: 'Address',
//                 validator: (v) => Validators.requiredField(v, label: 'Address'),
//               ),
//               const SizedBox(height: 12),
//
//               // Gender (required) - inline error via FormField
//               FormField<String>(
//                 validator: (_) => _gender == null ? 'Please select Gender' : null,
//                 builder: (state) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Text("Gender: "),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: RadioGroup<String>(
//                               groupValue: _gender,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _gender = val;
//                                   state.didChange(val); // inform the FormField
//                                 });
//                               },
//                               child: Row(
//                                 children: AppLists.genders.map((g) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(right: 16),
//                                     child: Row(
//                                       children: [
//                                         Radio<String>(value: g),
//                                         Text(g),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (state.hasError)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4.0, left: 12.0),
//                           child: Text(
//                             state.errorText!,
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.error,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 12),
//
//               // Cloth Type (required)
//               DropdownButtonFormField<String>(
//                 initialValue: _clothType,
//                 decoration: const InputDecoration(
//                   labelText: 'Cloth Type',
//                   border: OutlineInputBorder(),
//                   isDense: true,
//                 ),
//                 items: AppLists.clothTypes
//                     .map((t) => DropdownMenuItem(value: t, child: Text(t)))
//                     .toList(),
//                 onChanged: (val) => setState(() => _clothType = val),
//                 validator: (val) => val == null ? 'Select cloth type' : null,
//               ),
//               const SizedBox(height: 16),
//
//               const Text('Measurements', style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//
//               // Measurements (all required now)
//               MeasurementFields(
//                 chest: chestController,
//                 waist: waistController,
//                 length: lengthController,
//                 requiredFields: true, // 👈 make them required
//               ),
//               const SizedBox(height: 20),
//
//               // Save
//               PrimaryButton(
//                 text: 'Save Customer',
//                 onPressed: () async {
//                   hideKeyboard(context);
//
//                   // One unified validation call; shows errors inline where they are.
//                   if (!_formKey.currentState!.validate()) return;
//
//                   final customer = Customer(
//                     id: "",
//                     fullName: fullNameController.text.trim(),
//                     phoneNumber: phoneController.text.trim(),
//                     dob: _dob!.toIso8601String(),
//                     address: addressController.text.trim(),
//                     gender: _gender!,
//                     clothType: _clothType!,
//                     chest: double.parse(chestController.text.trim()),
//                     waist: double.parse(waistController.text.trim()),
//                     length: double.parse(lengthController.text.trim()),
//                   );
//
//                   await customerController.addCustomer(customer);
//
//                   if (!context.mounted) return;
//                   showSnack(context, "Customer added successfully");
//                   Navigator.pop(context);
//                 },
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

import '../../../../controllers/customer_controller.dart';
import '../../../../models/customer_model.dart';
import '../../../../core/constants.dart';
import '../../../../core/helpers.dart';
import '../../../../core/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/measurement_fields.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final chestController = TextEditingController();
  final waistController = TextEditingController();
  final lengthController = TextEditingController();

  String? _gender;
  String? _clothType;
  DateTime? _dob;

  bool _saving = false; // local saving flag

  @override
  void dispose() {
    fullNameController
      ..clear()
      ..dispose();
    phoneController
      ..clear()
      ..dispose();
    addressController
      ..clear()
      ..dispose();
    chestController
      ..clear()
      ..dispose();
    waistController
      ..clear()
      ..dispose();
    lengthController
      ..clear()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We rely on local _saving. No need to watch CustomerController.
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Customer')),
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(Gaps.md),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: [
                  // Full Name (required)
                  CustomTextField(
                    controller: fullNameController,
                    label: 'Full Name',
                    validator: (v) => Validators.requiredField(v, label: 'Full Name'),
                  ),
                  const SizedBox(height: Gaps.sm),

                  // Phone (required)
                  CustomTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: Gaps.sm),

                  // DOB (required) - inline error via FormField
                  FormField<DateTime>(
                    validator: (_) => _dob == null ? 'Please select Date of Birth' : null,
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              _dob == null
                                  ? 'Date of Birth: Not selected'
                                  : 'DOB: ${formatDate(_dob!)}',
                              style: const TextStyle(color: AppColors.text),
                            ),
                            trailing: ElevatedButton(
                              onPressed: _saving
                                  ? null
                                  : () async {
                                final picked = await pickDate(context, initial: _dob);
                                if (picked != null) {
                                  setState(() {
                                    _dob = picked;
                                    state.didChange(picked); // inform the FormField
                                  });
                                }
                              },
                              child: const Text('Pick Date'),
                            ),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: Gaps.sm),

                  // Address (required)
                  CustomTextField(
                    controller: addressController,
                    label: 'Address',
                    validator: (v) => Validators.requiredField(v, label: 'Address'),
                  ),
                  const SizedBox(height: Gaps.sm),

                  // Gender (required) - inline error via FormField
                  FormField<String>(
                    validator: (_) => _gender == null ? 'Please select Gender' : null,
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Gender: ', style: TextStyle(color: AppColors.text)),
                              const SizedBox(width: Gaps.sm),
                              Expanded(
                                child: RadioGroup<String>(
                                  groupValue: _gender,
                                  // ✅ Always pass a non-null function, guard inside:
                                  onChanged: (val) {
                                    if (_saving) return;
                                    setState(() {
                                      _gender = val;
                                      state.didChange(val); // inform the FormField
                                    });
                                  },
                                  child: Row(
                                    children: AppLists.genders.map((g) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: Gaps.md),
                                        child: Row(
                                          children: [
                                            Radio<String>(value: g),
                                            Text(g),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: Gaps.sm),

                  // Cloth Type (required)
                  DropdownButtonFormField<String>(
                    initialValue: _clothType,
                    decoration: const InputDecoration(
                      labelText: 'Cloth Type',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: AppLists.clothTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: _saving ? null : (val) => setState(() => _clothType = val),
                    validator: (val) => val == null ? 'Select cloth type' : null,
                  ),
                  const SizedBox(height: Gaps.md),

                  const Text(
                    'Measurements',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text),
                  ),
                  const SizedBox(height: Gaps.xs),

                  // Measurements (all required)
                  MeasurementFields(
                    chest: chestController,
                    waist: waistController,
                    length: lengthController,
                    requiredFields: true,
                  ),
                  const SizedBox(height: Gaps.lg),

                  // Save
                  PrimaryButton(
                    text: _saving ? 'Saving...' : 'Save Customer',
                    isLoading: _saving,
                    onPressed: _saving
                        ? null
                        : () async {
                      hideKeyboard(context);
                      if (!_formKey.currentState!.validate()) return;

                      final customer = Customer(
                        id: '', // Firestore will assign
                        fullName: fullNameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        dob: _dob!.toIso8601String(),
                        address: addressController.text.trim(),
                        gender: _gender!,
                        clothType: _clothType!,
                        chest: double.parse(chestController.text.trim()),
                        waist: double.parse(waistController.text.trim()),
                        length: double.parse(lengthController.text.trim()),
                      );

                      // Capture these BEFORE await
                      final messenger = ScaffoldMessenger.of(context);
                      final navigator  = Navigator.of(context);

                      setState(() => _saving = true);
                      final ok = await context.read<CustomerController>().addCustomer(customer);
                      if (!mounted) return;
                      setState(() => _saving = false);

                      // Safe usage after async gap
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(ok ? 'Customer added successfully' : 'Failed to add customer'),
                          backgroundColor: ok ? AppColors.success : AppColors.danger,
                          behavior: SnackBarBehavior.floating,
                          duration: Times.snack,
                        ),
                      );

                      if (ok) {
                        navigator.pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Fullscreen overlay during save (prevents taps)
          if (_saving) ...[
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withValues(alpha: 0.05),
            ),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
