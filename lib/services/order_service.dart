import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order_model.dart';

class OrderService {
  final CollectionReference ordersRef =
  FirebaseFirestore.instance.collection('orders');

  Future<void> addOrder(Order order) async {
    await ordersRef.add(order.toMap());
  }

  Future<List<Order>> getOrders(String customerId) async {
    final snap = await ordersRef.where('customerId', isEqualTo: customerId).get();
    return snap.docs
        .map((d) => Order.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Set<String>> customerIdsByStatus(String status) async {
    final snap = await ordersRef.where('status', isEqualTo: status).get();
    return snap.docs
        .map((d) => ((d.data() as Map<String, dynamic>)['customerId'] as String))
        .toSet();
  }
}
