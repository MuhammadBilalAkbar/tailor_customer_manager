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
// class EditCustomerScreen extends StatefulWidget {
//   final Customer customer;
//   const EditCustomerScreen({super.key, required this.customer});
//
//   @override
//   State<EditCustomerScreen> createState() => _EditCustomerScreenState();
// }
//
// class _EditCustomerScreenState extends State<EditCustomerScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   late final TextEditingController fullNameController;
//   late final TextEditingController phoneController;
//   late final TextEditingController addressController;
//   late final TextEditingController chestController;
//   late final TextEditingController waistController;
//   late final TextEditingController lengthController;
//
//   String? _gender;
//   String? _clothType;
//   DateTime? _dob;
//
//   @override
//   void initState() {
//     super.initState();
//     final c = widget.customer;
//     fullNameController = TextEditingController(text: c.fullName);
//     phoneController    = TextEditingController(text: c.phoneNumber);
//     addressController  = TextEditingController(text: c.address);
//     chestController    = TextEditingController(text: c.chest.toString());
//     waistController    = TextEditingController(text: c.waist.toString());
//     lengthController   = TextEditingController(text: c.length.toString());
//
//     _gender    = c.gender;
//     _clothType = c.clothType;
//     _dob       = DateTime.tryParse(c.dob);
//   }
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
//     final customerController = Provider.of<CustomerController>(context, listen: false);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Customer")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Full Name
//               CustomTextField(
//                 controller: fullNameController,
//                 label: 'Full Name',
//                 validator: (v) => Validators.requiredField(v, label: 'Full Name'),
//               ),
//               const SizedBox(height: 12),
//
//               // Phone
//               CustomTextField(
//                 controller: phoneController,
//                 label: 'Phone Number',
//                 keyboardType: TextInputType.phone,
//                 validator: Validators.phone,
//               ),
//               const SizedBox(height: 12),
//
//               // DOB (required) with inline validation
//               FormField<DateTime>(
//                 validator: (_) => _dob == null ? 'Please select Date of Birth' : null,
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
//                                 state.didChange(picked);
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
//               // Address
//               CustomTextField(
//                 controller: addressController,
//                 label: 'Address',
//                 validator: (v) => Validators.requiredField(v, label: 'Address'),
//               ),
//               const SizedBox(height: 12),
//
//               // Gender (required) with inline validation
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
//                                   state.didChange(val);
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
//               // Measurements (required)
//               MeasurementFields(
//                 chest: chestController,
//                 waist: waistController,
//                 length: lengthController,
//                 requiredFields: true,
//               ),
//               const SizedBox(height: 20),
//
//               PrimaryButton(
//                 text: 'Update Customer',
//                 onPressed: () async {
//                   hideKeyboard(context);
//                   if (!_formKey.currentState!.validate()) return;
//
//                   final updated = Customer(
//                     id: widget.customer.id,
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
//                   final ok = await customerController.updateCustomer(updated);
//
//                   if (!context.mounted) return;
//                   if (ok) {
//                     showSnack(context, "Customer updated");
//                     Navigator.pop(context);
//                   } else {
//                     showSnack(context, "Update failed", success: false);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// lib/views/screens/customer/edit_customer_screen.dart
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

class EditCustomerScreen extends StatefulWidget {
  final Customer customer;
  const EditCustomerScreen({super.key, required this.customer});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController fullNameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController chestController;
  late final TextEditingController waistController;
  late final TextEditingController lengthController;

  String? _gender;
  String? _clothType;
  DateTime? _dob;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    fullNameController = TextEditingController(text: c.fullName);
    phoneController    = TextEditingController(text: c.phoneNumber);
    addressController  = TextEditingController(text: c.address);
    chestController    = TextEditingController(text: c.chest.toString());
    waistController    = TextEditingController(text: c.waist.toString());
    lengthController   = TextEditingController(text: c.length.toString());
    _gender    = c.gender;
    _clothType = c.clothType;
    _dob       = DateTime.tryParse(c.dob);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    chestController.dispose();
    waistController.dispose();
    lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We use local _saving instead of listening to the controller.
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Edit Customer')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(Gaps.md),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Full Name
                  CustomTextField(
                    controller: fullNameController,
                    label: 'Full Name',
                    validator: (v) => Validators.requiredField(v, label: 'Full Name'),
                  ),
                  const SizedBox(height: Gaps.sm),

                  // Phone
                  CustomTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: Gaps.sm),

                  // DOB (inline validation)
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
                                    state.didChange(picked);
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

                  // Address
                  CustomTextField(
                    controller: addressController,
                    label: 'Address',
                    validator: (v) => Validators.requiredField(v, label: 'Address'),
                  ),
                  const SizedBox(height: Gaps.sm),

                  // Gender (required) — always pass a non-null handler and guard inside
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
                                  onChanged: (val) {
                                    if (_saving) return; // guard here
                                    setState(() {
                                      _gender = val;
                                      state.didChange(val);
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

                  // Cloth Type (nullable handler is acceptable per Flutter's API)
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

                  MeasurementFields(
                    chest: chestController,
                    waist: waistController,
                    length: lengthController,
                    requiredFields: true,
                  ),
                  const SizedBox(height: Gaps.lg),

                  // Update button with inline spinner and overlay
                  PrimaryButton(
                    text: _saving ? 'Updating...' : 'Update Customer',
                    isLoading: _saving,
                    onPressed: _saving
                        ? null
                        : () async {
                      hideKeyboard(context);

                      if (!_formKey.currentState!.validate()) return;

                      // Capture BEFORE await
                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);

                      final updated = Customer(
                        id: widget.customer.id,
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

                      setState(() => _saving = true);
                      final ok = await context.read<CustomerController>().updateCustomer(updated);
                      if (!mounted) return;
                      setState(() => _saving = false);

                      // Use captured messenger/navigator after async gap
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(ok ? 'Customer updated' : 'Update failed'),
                          backgroundColor: ok ? AppColors.success : AppColors.danger,
                          behavior: SnackBarBehavior.floating,
                          duration: Times.snack,
                        ),
                      );
                      if (ok) navigator.pop();
                    },
                  ),
                ],
              ),
            ),
          ),

          // Full-screen overlay while saving (blocks taps)
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
