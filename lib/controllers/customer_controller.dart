import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../services/customer_service.dart';

class CustomerController extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();

  List<Customer> _customers = [];
  bool _isLoading = false;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;

  Future<void> addCustomer(Customer customer) async {
    await _customerService.addCustomer(customer);
    await fetchCustomers(); // refresh after adding
  }

  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();
    _customers = await _customerService.getCustomers();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCustomer(String id, Customer customer) async {
    await _customerService.updateCustomer(id, customer);
    await fetchCustomers();
  }

  Future<void> deleteCustomer(String id) async {
    await _customerService.deleteCustomer(id);
    await fetchCustomers();
  }

  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
