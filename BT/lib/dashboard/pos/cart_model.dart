import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String name;
  final String barcode;
  String id;
  final int qty;
  final int currentQty;
  final int currentPrice;

  CartModel(
      {this.id = '',
      required this.name,
      required this.barcode,
      required this.qty,
      required this.currentQty,
      required this.currentPrice});
  factory CartModel.fromDocument(QueryDocumentSnapshot doc) {
    return CartModel(
      id: doc['id'],
      barcode: doc['barcode'],
      name: doc['name'],
      qty: doc['qty'],
      currentQty: doc['currentQty'],
      currentPrice: doc['currentPrice'],
    );
  }
}
