// class Customer {
//   String id;
//   String fullName;
//   String phoneNumber;
//   String dob;
//   String address;
//   String gender;
//   String clothType;
//   double chest;
//   double waist;
//   double length;
//
//   Customer({
//     required this.id,
//     required this.fullName,
//     required this.phoneNumber,
//     required this.dob,
//     required this.address,
//     required this.gender,
//     required this.clothType,
//     required this.chest,
//     required this.waist,
//     required this.length,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'fullName': fullName,
//       'phoneNumber': phoneNumber,
//       'dob': dob,
//       'address': address,
//       'gender': gender,
//       'clothType': clothType,
//       'chest': chest,
//       'waist': waist,
//       'length': length,
//     };
//   }
//
//   factory Customer.fromMap(String id, Map<String, dynamic> map) {
//     return Customer(
//       id: id,
//       fullName: map['fullName'],
//       phoneNumber: map['phoneNumber'],
//       dob: map['dob'],
//       address: map['address'],
//       gender: map['gender'],
//       clothType: map['clothType'],
//       chest: map['chest'],
//       waist: map['waist'],
//       length: map['length'],
//     );
//   }
// }


// lib/models/customer_model.dart
// lib/models/customer_model.dart
class Customer {
  String id;
  String fullName;
  String phoneNumber;
  String dob;        // ISO-8601 string
  String address;
  String gender;
  String clothType;
  double chest;
  double waist;
  double length;

  Customer({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.dob,
    required this.address,
    required this.gender,
    required this.clothType,
    required this.chest,
    required this.waist,
    required this.length,
  });

  /// Public, reusable converters
  static double asDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    final s = v.toString().trim();
    final parsed = double.tryParse(s.replaceAll(',', '.'));
    return parsed ?? 0.0;
  }

  static String asString(dynamic v) => (v ?? '').toString();

  /// Safe map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'address': address,
      'gender': gender,
      'clothType': clothType,
      'chest': chest,
      'waist': waist,
      'length': length,
    };
  }

  /// Robust factory: tolerates int/double/string/null from Firestore.
  factory Customer.fromMap(String id, Map<String, dynamic> map) {
    return Customer(
      id: id,
      fullName: Customer.asString(map['fullName']),
      phoneNumber: Customer.asString(map['phoneNumber']),
      dob: Customer.asString(map['dob']),
      address: Customer.asString(map['address']),
      gender: Customer.asString(map['gender']),
      clothType: Customer.asString(map['clothType']),
      chest: Customer.asDouble(map['chest']),
      waist: Customer.asDouble(map['waist']),
      length: Customer.asDouble(map['length']),
    );
  }

  /// Convenience for edits without mutating existing instance.
  Customer copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? dob,
    String? address,
    String? gender,
    String? clothType,
    double? chest,
    double? waist,
    double? length,
  }) {
    return Customer(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      clothType: clothType ?? this.clothType,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      length: length ?? this.length,
    );
  }
}
