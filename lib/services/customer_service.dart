import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class CustomerService {
  final CollectionReference customersRef =
  FirebaseFirestore.instance.collection('customers');

  Future<void> addCustomer(Customer customer) async {
    await customersRef.add(customer.toMap());
  }

  Future<List<Customer>> getCustomers() async {
    final snapshot = await customersRef.get();
    return snapshot.docs
        .map((doc) => Customer.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateCustomer(String id, Customer customer) async {
    await customersRef.doc(id).update(customer.toMap());
  }

  Future<void> deleteCustomer(String id) async {
    await customersRef.doc(id).delete();
  }
}
