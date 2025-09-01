// import 'package:flutter/material.dart';
// import '../models/customer_model.dart';
// import '../services/customer_service.dart';
//
// class CustomerController extends ChangeNotifier {
//   final CustomerService _customerService = CustomerService();
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   final List<Customer> _customers = [];
//   List<Customer> get customers => List.unmodifiable(_customers);
//
//   Future<void> fetchCustomers() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final list = await _customerService.getCustomers();
//       _customers
//         ..clear()
//         ..addAll(list);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<bool> addCustomer(Customer c) async {
//     try {
//       await _customerService.addCustomer(c);
//       await fetchCustomers();
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   Future<bool> updateCustomer(Customer c) async {
//     try {
//       await _customerService.updateCustomer(c);
//       // update local cache quickly or refetch
//       final idx = _customers.indexWhere((x) => x.id == c.id);
//       if (idx != -1) {
//         _customers[idx] = c;
//         notifyListeners();
//       } else {
//         await fetchCustomers();
//       }
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   Future<bool> deleteCustomer(String id) async {
//     try {
//       await _customerService.deleteCustomer(id);
//       _customers.removeWhere((x) => x.id == id);
//       notifyListeners();
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   Customer? getCustomerById(String id) {
//     try {
//       return _customers.firstWhere((c) => c.id == id);
//     } catch (_) {
//       return null;
//     }
//   }
// }

// lib/controllers/customer_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../services/customer_service.dart';

class CustomerController extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();

  bool _isLoading = false;
  String? _lastError;

  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  final List<Customer> _customers = [];
  List<Customer> get customers => List.unmodifiable(_customers);

  StreamSubscription<List<Customer>>? _sub; // optional real-time

  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? message) {
    _lastError = message;
    // notify in the calling flow so UI updates together with state changes
  }

  /// One-time fetch (what your screens currently call)
  Future<void> fetchCustomers() async {
    _setLoading(true);
    try {
      final list = await _customerService.getCustomers();
      _customers
        ..clear()
        ..addAll(list);
      _setError(null);
    } catch (_) {
      _setError('Failed to load customers');
    } finally {
      _setLoading(false);
    }
  }

  /// Optional: start real-time updates (call e.g. in initState instead of fetchCustomers)
  void listenCustomers() {
    // Avoid multiple listeners
    _sub?.cancel();
    _setLoading(true);
    _sub = _customerService.watchCustomers().listen(
          (list) {
        _customers
          ..clear()
          ..addAll(list);
        _setError(null);
        _setLoading(false);
      },
      onError: (_) {
        _setError('Failed to listen for updates');
        _setLoading(false);
      },
    );
  }

  /// Optional: stop real-time updates (e.g., in dispose or when leaving screen)
  void stopListening() {
    _sub?.cancel();
    _sub = null;
  }

  Future<bool> addCustomer(Customer c) async {
    try {
      await _customerService.addCustomer(c);
      // If not listening in real-time, ensure UI refreshes:
      if (_sub == null) {
        await fetchCustomers();
      }
      _setError(null);
      return true;
    } catch (_) {
      _setError('Failed to add customer');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCustomer(Customer c) async {
    try {
      await _customerService.updateCustomer(c);

      // Fast local update when not in real-time mode
      if (_sub == null) {
        final idx = _customers.indexWhere((x) => x.id == c.id);
        if (idx != -1) {
          _customers[idx] = c;
          notifyListeners();
        } else {
          await fetchCustomers();
        }
      }

      _setError(null);
      return true;
    } catch (_) {
      _setError('Failed to update customer');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCustomer(String id) async {
    try {
      await _customerService.deleteCustomer(id);

      // Fast local update when not in real-time mode
      if (_sub == null) {
        _customers.removeWhere((x) => x.id == id);
        notifyListeners();
      }

      _setError(null);
      return true;
    } catch (_) {
      _setError('Failed to delete customer');
      notifyListeners();
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

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
