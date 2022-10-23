class Supplier {
  String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  Supplier({
    this.id = '',
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };

  static Supplier fromJson(Map<String, dynamic> json) => Supplier(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address']);
}
