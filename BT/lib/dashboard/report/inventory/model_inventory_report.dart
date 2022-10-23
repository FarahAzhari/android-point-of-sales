class ContentI {
  final List<Inventory> inventory;

  ContentI({required this.inventory});
  factory ContentI.fromJson(Map<String, dynamic> json) => ContentI(
      inventory: List<Inventory>.from(
          json["items"].map((x) => Inventory.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(inventory.map((x) => x.toJson())),
      };
}

class Inventory {
  final String date;
  final String barcode;
  final String name;
  final int sellingPrice;
  final int qty;

  Inventory({
    required this.date,
    required this.barcode,
    required this.name,
    required this.sellingPrice,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'barcode': barcode,
        'name': name,
        'sellingPrice': sellingPrice,
        'qty': qty,
      };

  static Inventory fromJson(Map<String, dynamic> json) => Inventory(
        date: json['date'],
        barcode: json['barcode'],
        name: json['name'],
        sellingPrice: json['sellingPrice'],
        qty: json['qty'],
      );
}
