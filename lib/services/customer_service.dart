import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class CustomerService {
  final CollectionReference customersRef =
  FirebaseFirestore.instance.collection('customers');

  Future<List<Customer>> getCustomers() async {
    final snap = await customersRef.get();
    return snap.docs
        .map((d) => Customer.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<String> addCustomer(Customer c) async {
    final doc = await customersRef.add(c.toMap());
    return doc.id;
  }

  Future<void> updateCustomer(Customer c) {
    return customersRef.doc(c.id).update(c.toMap());
  }

  Future<void> deleteCustomer(String id) {
    return customersRef.doc(id).delete();
  }
}
