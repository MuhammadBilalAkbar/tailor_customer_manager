import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderController extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<void> addOrder(Order order) async {
    await _orderService.addOrder(order);
    await fetchOrders(order.customerId);
  }

  Future<void> fetchOrders(String customerId) async {
    _orders = await _orderService.getOrders(customerId);
    notifyListeners();
  }
}
