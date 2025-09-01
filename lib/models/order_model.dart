// class Order {
//   String id;
//   String customerId;
//   DateTime orderDate;
//   DateTime deliveryDate;
//   String status;
//   String notes;
//
//   Order({
//     required this.id,
//     required this.customerId,
//     required this.orderDate,
//     required this.deliveryDate,
//     required this.status,
//     required this.notes,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'customerId': customerId,
//       'orderDate': orderDate.toIso8601String(),
//       'deliveryDate': deliveryDate.toIso8601String(),
//       'status': status,
//       'notes': notes,
//     };
//   }
//
//   factory Order.fromMap(String id, Map<String, dynamic> map) {
//     return Order(
//       id: id,
//       customerId: map['customerId'] ?? '',
//       orderDate: DateTime.tryParse(map['orderDate'] ?? '') ?? DateTime.now(),
//       deliveryDate: DateTime.tryParse(map['deliveryDate'] ?? '') ?? DateTime.now(),
//       status: map['status'] ?? 'Pending',
//       notes: map['notes'] ?? '',
//     );
//   }
// }

// lib/models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String customerId;
  DateTime orderDate;
  DateTime deliveryDate;
  String status; // 'Pending' | 'Completed'
  String notes;

  Order({
    required this.id,
    required this.customerId,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.notes,
  });

  /// Public, reusable converters
  static DateTime asDate(dynamic v) {
    if (v == null) return DateTime.now();

    if (v is Timestamp) return v.toDate(); // Firestore Timestamp
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v); // epoch millis

    if (v is String) {
      final parsed = DateTime.tryParse(v);
      if (parsed != null) return parsed;
    }
    return DateTime.now();
  }

  static String asString(dynamic v, {String fallback = ''}) =>
      (v == null) ? fallback : v.toString();

  /// Keep only the two canonical statuses: 'Pending' | 'Completed'
  static String normalizeStatus(dynamic v) {
    final s = asString(v, fallback: 'Pending').trim();
    final lower = s.toLowerCase();
    if (lower == 'completed') return 'Completed';
    return 'Pending';
  }

  /// Map used by current codebase (kept as ISO strings to avoid breaking changes).
  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  /// Robust factory: accepts Firestore Timestamp, ISO-8601 string, or epoch millis.
  factory Order.fromMap(String id, Map<String, dynamic> map) {
    return Order(
      id: id,
      customerId: Order.asString(map['customerId']),
      orderDate: Order.asDate(map['orderDate']),
      deliveryDate: Order.asDate(map['deliveryDate']),
      status: Order.normalizeStatus(map['status']),
      notes: Order.asString(map['notes']),
    );
  }

  /// Convenience for edits without mutating existing instance.
  Order copyWith({
    String? id,
    String? customerId,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? status,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
