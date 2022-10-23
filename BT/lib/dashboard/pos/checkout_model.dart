// To parse this JSON data, do
//
//     final checkout = checkoutFromJson(jsonString);

import 'dart:convert';

Checkout checkoutFromJson(String str) => Checkout.fromJson(json.decode(str));

String checkoutToJson(Checkout data) => json.encode(data.toJson());

class Checkout {
  Checkout({
    required this.date,
    required this.name,
    required this.cash,
    required this.change,
    required this.total,
    required this.items,
  });

  String date;
  String name;
  int cash;
  int change;
  int total;
  List<Item> items;

  factory Checkout.fromJson(Map<String, dynamic> json) => Checkout(
        date: json["date"],
        name: json["name"],
        cash: json["cash"],
        change: json["change"],
        total: json["total"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "name": name,
        "cash": cash,
        "change": change,
        "total": total,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.name,
    required this.barcode,
    required this.price,
    required this.qty,
    required this.subtotal,
  });

  String name;
  String barcode;
  int price;
  int qty;
  int subtotal;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        barcode: json["barcode"],
        price: json["price"],
        qty: json["qty"],
        subtotal: json["subtotal"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "barcode": barcode,
        "price": price,
        "qty": qty,
        "subtotal": subtotal,
      };
}
