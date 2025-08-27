class Customer {
  String id;
  String fullName;
  String phoneNumber;
  String dob;
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

  factory Customer.fromMap(String id, Map<String, dynamic> map) {
    return Customer(
      id: id,
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      dob: map['dob'],
      address: map['address'],
      gender: map['gender'],
      clothType: map['clothType'],
      chest: map['chest'],
      waist: map['waist'],
      length: map['length'],
    );
  }
}
