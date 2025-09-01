// import 'package:flutter/material.dart';
// import '../models/order_model.dart';
// import '../services/order_service.dart';
//
// class OrderController extends ChangeNotifier {
//   final OrderService _orderService = OrderService();
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   final List<Order> _orders = [];
//   List<Order> get orders => List.unmodifiable(_orders);
//
//   // ✅ NEW: cached sets for status filtering
//   Set<String>? _pendingCustomerIds;
//   Set<String>? _completedCustomerIds;
//
//   Set<String>? get pendingCustomerIds => _pendingCustomerIds;
//   Set<String>? get completedCustomerIds => _completedCustomerIds;
//
//   Future<void> fetchOrders(String customerId) async {
//     _isLoading = true; notifyListeners();
//     try {
//       final list = await _orderService.getOrders(customerId);
//       _orders
//         ..clear()
//         ..addAll(list);
//     } finally {
//       _isLoading = false; notifyListeners();
//     }
//   }
//
//   // ✅ NEW: preload sets so UI can filter quickly
//   Future<void> preloadCustomerStatusSets() async {
//     // don’t re-fetch if already cached
//     if (_pendingCustomerIds != null && _completedCustomerIds != null) return;
//
//     _isLoading = true; notifyListeners();
//     try {
//       final pending = await _orderService.customerIdsByStatus('Pending');
//       final completed = await _orderService.customerIdsByStatus('Completed');
//       _pendingCustomerIds = pending;
//       _completedCustomerIds = completed;
//     } finally {
//       _isLoading = false; notifyListeners();
//     }
//   }
//
//   // (Optional) keep caches fresh when adding an order
//   Future<bool> addOrder(Order order) async {
//     try {
//       await _orderService.addOrder(order);
//       // best-effort cache update
//       if (order.status == 'Pending') {
//         _pendingCustomerIds ??= {};
//         _pendingCustomerIds!.add(order.customerId);
//         _completedCustomerIds?.remove(order.customerId);
//       } else if (order.status == 'Completed') {
//         _completedCustomerIds ??= {};
//         _completedCustomerIds!.add(order.customerId);
//         _pendingCustomerIds?.remove(order.customerId);
//       }
//       notifyListeners();
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
// }


// lib/controllers/order_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderController extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool _isLoading = false;
  String? _lastError;

  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  /// Orders for the *currently selected* customer (via fetchOrders / listenOrders).
  final List<Order> _orders = [];
  List<Order> get orders => List.unmodifiable(_orders);

  /// Track which customerId the current [_orders] belong to.
  String? _currentCustomerId;

  /// Cached sets for fast status filtering (optional feature).
  Set<String>? _pendingCustomerIds;
  Set<String>? _completedCustomerIds;

  Set<String>? get pendingCustomerIds => _pendingCustomerIds;
  Set<String>? get completedCustomerIds => _completedCustomerIds;

  StreamSubscription<List<Order>>? _ordersSub; // optional real-time

  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? message) {
    _lastError = message;
    // notify where UI state also changes
  }

  /// One-time fetch all orders for a customer and expose them via [orders].
  Future<void> fetchOrders(String customerId) async {
    _currentCustomerId = customerId;
    _setLoading(true);
    try {
      final list = await _orderService.getOrders(customerId);
      _orders
        ..clear()
        ..addAll(list);
      _setError(null);
    } catch (_) {
      _setError('Failed to load orders');
    } finally {
      _setLoading(false);
    }
  }

  /// Optional: start real-time orders updates for a customer.
  void listenOrders(String customerId) {
    _currentCustomerId = customerId;
    _ordersSub?.cancel();
    _setLoading(true);

    _ordersSub = _orderService.watchOrders(customerId).listen(
          (list) {
        _orders
          ..clear()
          ..addAll(list);
        _setError(null);
        _setLoading(false);
      },
      onError: (_) {
        _setError('Failed to listen for order updates');
        _setLoading(false);
      },
    );
  }

  /// Optional: stop real-time subscription.
  void stopListening() {
    _ordersSub?.cancel();
    _ordersSub = null;
  }

  /// Preload customerId sets for 'Pending' / 'Completed' without blocking UI.
  Future<void> preloadCustomerStatusSets() async {
    if (_pendingCustomerIds != null && _completedCustomerIds != null) return;
    try {
      final pending = await _orderService.customerIdsByStatus('Pending');
      final completed = await _orderService.customerIdsByStatus('Completed');
      _pendingCustomerIds = pending;
      _completedCustomerIds = completed;
      notifyListeners(); // in case UI reacts to these sets
    } catch (_) {
      _setError('Failed to preload order status sets');
    }
  }

  /// Add a new order. Updates cached status sets and refreshes the active list
  /// if it belongs to the currently viewed customer.
  Future<bool> addOrder(Order order) async {
    try {
      await _orderService.addOrder(order);

      // Keep status sets fresh.
      if (order.status == 'Pending') {
        _pendingCustomerIds ??= {};
        _pendingCustomerIds!.add(order.customerId);
        _completedCustomerIds?.remove(order.customerId);
      } else if (order.status == 'Completed') {
        _completedCustomerIds ??= {};
        _completedCustomerIds!.add(order.customerId);
        _pendingCustomerIds?.remove(order.customerId);
      }

      // If the user is currently viewing this customer's orders, refresh list.
      if (_currentCustomerId == order.customerId) {
        await fetchOrders(order.customerId); // shows spinner on that screen
      } else {
        notifyListeners();
      }

      _setError(null);
      return true;
    } catch (_) {
      _setError('Failed to add order');
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _ordersSub?.cancel();
    super.dispose();
  }
}
