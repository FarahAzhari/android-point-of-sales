class Issue {
  String id;
  final String date;
  final String barcode;
  final String name;
  final int costPrice;
  final int qty;
  final String supplierId;

  Issue(
      {this.id = '',
      required this.date,
      required this.barcode,
      required this.name,
      required this.costPrice,
      required this.qty,
      required this.supplierId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'barcode': barcode,
        'name': name,
        'costPrice': costPrice,
        'qty': qty,
        'dropdownSupplier': supplierId,
      };

  static Issue fromJson(Map<String, dynamic> json) => Issue(
      id: json['id'],
      date: json['date'],
      barcode: json['barcode'],
      name: json['name'],
      costPrice: json['costPrice'],
      qty: json['qty'],
      supplierId: json['dropdownSupplier']);
}
