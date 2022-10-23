import 'package:bintang_timur/dashboard/pos/cart_provider.dart';
import 'package:bintang_timur/dashboard/pos/checkout.dart';
import 'package:bintang_timur/dashboard/pos/counter_provider.dart';
import 'package:bintang_timur/dashboard/report/invoice/list_invoice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class cart extends StatefulWidget {
  const cart({Key? key}) : super(key: key);

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final _counter = Provider.of<Counter>(context, listen: true);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();

    return Scaffold(
        bottomNavigationBar: cartProvider.getCartList.isEmpty
            ? Text('')
            : SizedBox(
                height: 160.h,
                width: 100.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black, onPrimary: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => checkout()),
                    );
                  },
                  child: Text(
                    'Checkout',
                    style: TextStyle(fontSize: 50.sp, color: Colors.white),
                  ),
                )),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Cart',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.receipt,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListInvoice()),
                  );
                },
              ),
            ),
            SizedBox(
              width: 20.w,
            )
          ],
        ),
        body: cartProvider.getCartList.isEmpty
            ? Center(
                child: Text('No Item Added'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: cartProvider.getCartList.length,
                itemBuilder: (context, index) {
                  var doc = cartProvider.cartList[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 30.h),
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc.name,
                              style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            'Price: \Rp${doc.currentPrice * doc.currentQty}',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text('in Stock: ${doc.qty}',
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (_counter.value > 1) {
                                  setState(() {
                                    _counter.decrement();
                                    firestoreRef
                                        .collection('transaction')
                                        .doc('cart')
                                        .collection('detail cart')
                                        .doc(doc.id)
                                        .update({
                                      'currentQty': _counter.value,
                                      'price':
                                          doc.currentPrice * _counter.value,
                                    });
                                  });
                                } else {
                                  firestoreRef
                                      .collection('transaction')
                                      .doc('cart')
                                      .collection('detail cart')
                                      .doc(doc.id)
                                      .delete();
                                }
                              },
                              icon: Icon(Icons.remove_circle,
                                  color: Colors.black)),
                          Text(doc.currentQty.toString()),
                          IconButton(
                              onPressed: () {
                                if (_counter.value < doc.qty) {
                                  setState(() {
                                    _counter.increment();
                                    firestoreRef
                                        .collection('transaction')
                                        .doc('cart')
                                        .collection('detail cart')
                                        .doc(doc.id)
                                        .update({
                                      'currentQty': _counter.value,
                                      'price':
                                          doc.currentPrice * _counter.value,
                                    });
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
                  );
                }));
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }
}
