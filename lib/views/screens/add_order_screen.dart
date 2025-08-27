import 'package:flutter/material.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      final orderData = {
        "customerName": _customerNameController.text,
        "product": _productController.text,
        "quantity": int.parse(_quantityController.text),
        "price": double.parse(_priceController.text),
        "date": _selectedDate?.toIso8601String(),
        "notes": _notesController.text,
      };

      // TODO: Send this data to your backend / Firebase / API
      print("Order submitted: $orderData");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order submitted successfully!')),
      );

      // Clear fields after submission
      _formKey.currentState!.reset();
      setState(() {
        _selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Order")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(labelText: "Customer Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter customer name" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _productController,
                  decoration: const InputDecoration(labelText: "Product"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter product name" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Quantity"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter quantity" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price"),
                  validator: (value) => value!.isEmpty ? "Enter price" : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? "No date chosen"
                            : "Date: ${_selectedDate!.toLocal()}".split(' ')[0],
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text("Choose Date"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: "Notes"),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitOrder,
                  child: const Text("Submit Order"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
