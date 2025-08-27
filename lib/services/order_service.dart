import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order_model.dart';

class OrderService {
  final CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');

  Future<void> addOrder(Order order) async {
    await ordersRef.add(order.toMap());
  }

  Future<List<Order>> getOrders(String customerId) async {
    final snapshot = await ordersRef.where('customerId', isEqualTo: customerId).get();
    return snapshot.docs.map((doc) => Order.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }
}
