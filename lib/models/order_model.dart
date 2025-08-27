class Order {
  String id;
  String customerId;
  DateTime orderDate;
  DateTime deliveryDate;
  String status;
  String notes;

  Order({
    required this.id,
    required this.customerId,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  factory Order.fromMap(String id, Map<String, dynamic> map) {
    return Order(
      id: id,
      customerId: map['customerId'] ?? '',
      orderDate: DateTime.tryParse(map['orderDate'] ?? '') ?? DateTime.now(),
      deliveryDate: DateTime.tryParse(map['deliveryDate'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? 'Pending',
      notes: map['notes'] ?? '',
    );
  }
}
