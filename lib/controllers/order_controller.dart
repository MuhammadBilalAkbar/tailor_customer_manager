import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderController extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Order> _orders = [];
  List<Order> get orders => List.unmodifiable(_orders);

  // ✅ NEW: cached sets for status filtering
  Set<String>? _pendingCustomerIds;
  Set<String>? _completedCustomerIds;

  Set<String>? get pendingCustomerIds => _pendingCustomerIds;
  Set<String>? get completedCustomerIds => _completedCustomerIds;

  Future<void> fetchOrders(String customerId) async {
    _isLoading = true; notifyListeners();
    try {
      final list = await _orderService.getOrders(customerId);
      _orders
        ..clear()
        ..addAll(list);
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  // ✅ NEW: preload sets so UI can filter quickly
  Future<void> preloadCustomerStatusSets() async {
    // don’t re-fetch if already cached
    if (_pendingCustomerIds != null && _completedCustomerIds != null) return;

    _isLoading = true; notifyListeners();
    try {
      final pending = await _orderService.customerIdsByStatus('Pending');
      final completed = await _orderService.customerIdsByStatus('Completed');
      _pendingCustomerIds = pending;
      _completedCustomerIds = completed;
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  // (Optional) keep caches fresh when adding an order
  Future<bool> addOrder(Order order) async {
    try {
      await _orderService.addOrder(order);
      // best-effort cache update
      if (order.status == 'Pending') {
        _pendingCustomerIds ??= {};
        _pendingCustomerIds!.add(order.customerId);
        _completedCustomerIds?.remove(order.customerId);
      } else if (order.status == 'Completed') {
        _completedCustomerIds ??= {};
        _completedCustomerIds!.add(order.customerId);
        _pendingCustomerIds?.remove(order.customerId);
      }
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
