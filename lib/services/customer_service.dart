// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/customer_model.dart';
//
// class CustomerService {
//   final CollectionReference customersRef =
//   FirebaseFirestore.instance.collection('customers');
//
//   Future<List<Customer>> getCustomers() async {
//     final snap = await customersRef.get();
//     return snap.docs
//         .map((d) => Customer.fromMap(d.id, d.data() as Map<String, dynamic>))
//         .toList();
//   }
//
//   Future<String> addCustomer(Customer c) async {
//     final doc = await customersRef.add(c.toMap());
//     return doc.id;
//   }
//
//   Future<void> updateCustomer(Customer c) {
//     return customersRef.doc(c.id).update(c.toMap());
//   }
//
//   Future<void> deleteCustomer(String id) {
//     return customersRef.doc(id).delete();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class CustomerService {
  final CollectionReference customersRef =
  FirebaseFirestore.instance.collection('customers');

  Future<List<Customer>> getCustomers() async {
    try {
      final snap = await customersRef.orderBy('fullName').get();
      return snap.docs
          .map((d) => Customer.fromMap(d.id, d.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException {
      rethrow;
    }
  }

  /// Real-time stream (optional; use in controller if you want live updates)
  Stream<List<Customer>> watchCustomers() {
    return customersRef.orderBy('fullName').snapshots().map(
          (snap) => snap.docs
          .map((d) => Customer.fromMap(d.id, d.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<String> addCustomer(Customer c) async {
    try {
      final doc = await customersRef.add(c.toMap());
      return doc.id;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> updateCustomer(Customer c) {
    try {
      return customersRef.doc(c.id).update(c.toMap());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> deleteCustomer(String id) {
    try {
      return customersRef.doc(id).delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
