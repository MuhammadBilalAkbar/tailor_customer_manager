// import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
// import '../models/order_model.dart';
//
// class OrderService {
//   final CollectionReference ordersRef =
//   FirebaseFirestore.instance.collection('orders');
//
//   Future<void> addOrder(Order order) async {
//     await ordersRef.add(order.toMap());
//   }
//
//   Future<List<Order>> getOrders(String customerId) async {
//     final snap = await ordersRef.where('customerId', isEqualTo: customerId).get();
//     return snap.docs
//         .map((d) => Order.fromMap(d.id, d.data() as Map<String, dynamic>))
//         .toList();
//   }
//
//   Future<Set<String>> customerIdsByStatus(String status) async {
//     final snap = await ordersRef.where('status', isEqualTo: status).get();
//     return snap.docs
//         .map((d) => ((d.data() as Map<String, dynamic>)['customerId'] as String))
//         .toSet();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order_model.dart';

class OrderService {
  final CollectionReference<Map<String, dynamic>> ordersRef =
  FirebaseFirestore.instance.collection('orders');

  Future<void> addOrder(Order order) async {
    try {
      await ordersRef.add(order.toMap());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<List<Order>> getOrders(String customerId) async {
    try {
      final snap =
      await ordersRef.where('customerId', isEqualTo: customerId).get();

      final list = snap.docs
          .map((d) => Order.fromMap(d.id, d.data()))
          .toList();

      // Sort newest first without requiring a Firestore index
      list.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return list;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<Set<String>> customerIdsByStatus(String status) async {
    try {
      final snap = await ordersRef.where('status', isEqualTo: status).get();
      return snap.docs
          .map((d) => d.data()['customerId'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();
    } on FirebaseException {
      rethrow;
    }
  }

  /// Optional real-time stream (not used by current screens).
  Stream<List<Order>> watchOrders(String customerId) {
    return ordersRef
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map((d) => Order.fromMap(d.id, d.data()))
          .toList();
      list.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return list;
    });
  }
}
