import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/customer_controller.dart';
import '../../../models/customer_model.dart';

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

  final List<String> clothTypes = ["Shirt", "Trouser", "Kurta", "Coat"];

  @override
  Widget build(BuildContext context) {
    final customerController = Provider.of<CustomerController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Customer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: (val) => val == null || val.isEmpty ? "Enter full name" : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                  validator: (val) => val == null || val.isEmpty ? "Enter phone number" : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dob == null
                            ? "Date of Birth: Not selected"
                            : "DOB: ${_dob!.day}/${_dob!.month}/${_dob!.year}",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _dob = picked);
                        }
                      },
                      child: const Text("Pick Date"),
                    ),
                  ],
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                  validator: (val) => val == null || val.isEmpty ? "Enter address" : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Gender: "),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "Male",
                            groupValue: _gender,
                            onChanged: (val) => setState(() => _gender = val),
                          ),
                          const Text("Male"),
                          Radio<String>(
                            value: "Female",
                            groupValue: _gender,
                            onChanged: (val) => setState(() => _gender = val),
                          ),
                          const Text("Female"),
                        ],
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: _clothType,
                  hint: const Text("Select Cloth Type"),
                  items: clothTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (val) => setState(() => _clothType = val),
                  validator: (val) => val == null ? "Select cloth type" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: chestController,
                  decoration: const InputDecoration(labelText: "Chest (inches)"),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: waistController,
                  decoration: const InputDecoration(labelText: "Waist (inches)"),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: lengthController,
                  decoration: const InputDecoration(labelText: "Length (inches)"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _dob != null && _gender != null) {
                      final customer = Customer(
                        id: "", // Firestore will generate ID
                        fullName: fullNameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        dob: _dob!.toIso8601String(),
                        address: addressController.text.trim(),
                        gender: _gender!,
                        clothType: _clothType!,
                        chest: double.tryParse(chestController.text) ?? 0,
                        waist: double.tryParse(waistController.text) ?? 0,
                        length: double.tryParse(lengthController.text) ?? 0,
                      );

                      await customerController.addCustomer(customer);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Customer added successfully")),
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all required fields")),
                      );
                    }
                  },
                  child: const Text("Save Customer"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
