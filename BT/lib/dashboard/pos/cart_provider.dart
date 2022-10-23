import 'package:bintang_timur/dashboard/pos/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  CartModel? cartModel;

  Future getCartData() async {
    List<CartModel> newcartList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transaction')
        .doc('cart')
        .collection('detail cart')
        .get();

    querySnapshot.docs.forEach((element) {
      cartModel = CartModel.fromDocument(element);
      notifyListeners();
      newcartList.add(cartModel!);
    });
    cartList = newcartList;
    notifyListeners();
  }

  List<CartModel> get getCartList {
    return cartList;
  }

  Future<void> deleteCart() async {
    FirebaseFirestore.instance.collection('transaction').doc('cart').delete();
  }

  void clearItems() {
    cartList.clear();
    notifyListeners();
  }

  int subTotal() {
    int subtotal = 0;

    cartList.forEach((element) {
      subtotal += element.currentPrice * element.currentQty;
    });
    return subtotal;
  }
}
