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
    final customerController = Provider.of<CustomerController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Customer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: fullNameController,
                label: 'Full Name',
                validator: (v) => Validators.requiredField(v, label: 'Full Name'),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _dob == null ? "Date of Birth: Not selected" : "DOB: ${formatDate(_dob!)}",
                ),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final picked = await pickDate(context, initial: _dob);
                    if (picked != null) setState(() => _dob = picked);
                  },
                  child: const Text("Pick Date"),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: addressController,
                label: 'Address',
                validator: (v) => Validators.requiredField(v, label: 'Address'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("Gender: "),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RadioGroup<String>(
                      groupValue: _gender,
                      onChanged: (val) => setState(() => _gender = val),
                      child: Row(
                        children: AppLists.genders.map((g) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
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
              const SizedBox(height: 12),
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
                onChanged: (val) => setState(() => _clothType = val),
                validator: (val) => val == null ? 'Select cloth type' : null,
              ),
              const SizedBox(height: 16),
              const Text('Measurements', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              MeasurementFields(
                chest: chestController,
                waist: waistController,
                length: lengthController,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Save Customer',
                onPressed: () async {
                  hideKeyboard(context);

                  if (_dob == null) {
                    showSnack(context, 'Please select Date of Birth', success: false);
                    return;
                  }
                  if (_gender == null) {
                    showSnack(context, 'Please select Gender', success: false);
                    return;
                  }
                  if (!_formKey.currentState!.validate()) return;

                  final customer = Customer(
                    id: "",
                    fullName: fullNameController.text.trim(),
                    phoneNumber: phoneController.text.trim(),
                    dob: _dob!.toIso8601String(),
                    address: addressController.text.trim(),
                    gender: _gender!,
                    clothType: _clothType!,
                    chest: parseDoubleOrZero(chestController.text),
                    waist: parseDoubleOrZero(waistController.text),
                    length: parseDoubleOrZero(lengthController.text),
                  );

                  await customerController.addCustomer(customer);

                  if (!context.mounted) return;
                  showSnack(context, "Customer added successfully");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
