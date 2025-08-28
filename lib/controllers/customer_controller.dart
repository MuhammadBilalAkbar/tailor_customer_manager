import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../services/customer_service.dart';

class CustomerController extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Customer> _customers = [];
  List<Customer> get customers => List.unmodifiable(_customers);

  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final list = await _customerService.getCustomers();
      _customers
        ..clear()
        ..addAll(list);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCustomer(Customer c) async {
    try {
      await _customerService.addCustomer(c);
      await fetchCustomers();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateCustomer(Customer c) async {
    try {
      await _customerService.updateCustomer(c);
      // update local cache quickly or refetch
      final idx = _customers.indexWhere((x) => x.id == c.id);
      if (idx != -1) {
        _customers[idx] = c;
        notifyListeners();
      } else {
        await fetchCustomers();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteCustomer(String id) async {
    try {
      await _customerService.deleteCustomer(id);
      _customers.removeWhere((x) => x.id == id);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
