class Customer {
  String id;
  final String name;
  final String email;
  final String phone;

  Customer({
    this.id = '',
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
      };

  static Customer fromJson(Map<String, dynamic> json) => Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone']);
}
