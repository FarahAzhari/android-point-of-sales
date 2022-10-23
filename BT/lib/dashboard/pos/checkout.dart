import 'package:bintang_timur/dashboard/pos/cart_provider.dart';
import 'package:bintang_timur/dashboard/pos/counter_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class checkout extends StatefulWidget {
  const checkout({Key? key}) : super(key: key);

  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout>
    with SingleTickerProviderStateMixin {
  final TextEditingController _cash = TextEditingController();
  final date = TextEditingController();
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  var customerId;
  int? change;
  late AnimationController controller;
  int? index;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
    );
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        controller.reset();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _counter = Provider.of<Counter>(context, listen: true);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();
    int subTotal = cartProvider.subTotal();
    int total = subTotal;

    if (cartProvider.getCartList.isEmpty) {
      setState(() {
        total = 0;
      });
    }

    _calculate() {
      //perform validation then do the math
      int? amount = int.tryParse(_cash.text);
      if (amount != null) {
        setState(() {
          final changeFee = amount - total;
          change = changeFee;
        });
      } else {
        print('Invalid input');
        setState(() {
          change = null;
        });
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade200,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.grey.shade200,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: firestoreRef
                          .collection('customer')
                          .orderBy('name')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );

                        return Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: DropdownButtonFormField(
                            value: customerId,
                            isDense: true,
                            onChanged: (valueSelectedByUser) {
                              _showMessage(
                                  'Selected Customer is $valueSelectedByUser');
                              setState(() {
                                customerId = valueSelectedByUser;
                              });
                            },
                            hint: Text('Choose Customer'),
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                value: document['name'],
                                child: Text(document['name']),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                  SizedBox(height: 24.h),
                  DateTimeField(
                      controller: date,
                      decoration: decoration('Date'),
                      format: DateFormat("dd-MM-yyyy"),
                      onShowPicker: (context, currentValue) => showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025),
                          initialDate: currentValue ?? DateTime.now())),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Type the amount of cash'),
                    controller: _cash,
                    // onEditingComplete: calculate(),
                    onFieldSubmitted: _calculate(),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: cartProvider.getCartList.isEmpty
                ? Center(
                    child: Text('No Item Added'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: cartProvider.getCartList.length,
                    itemBuilder: (context, index) {
                      var doc = cartProvider.cartList[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 70.w),
                        leading: Text('${index + 1}'),
                        title: Text(doc.name,
                            style: TextStyle(
                                fontSize: 45.sp, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Price: \Rp${doc.currentPrice * doc.currentQty}',
                          style: TextStyle(color: Colors.green),
                        ),
                        trailing: Text('Qty: ${doc.currentQty}',
                            style: TextStyle(color: Colors.blue)),
                      );
                    }),
          ),
          Divider(
            thickness: 2,
          ),
          Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Cash'),
                  SizedBox(
                    width: 50.w,
                  ),
                  Text('\Rp${_cash.text}'),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Change'),
                  SizedBox(
                    width: 50.w,
                  ),
                  Text('\Rp$change'),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 50.w,
                  ),
                  Text(
                    'Total',
                    style:
                        TextStyle(fontSize: 55.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 670.w,
                  ),
                  Text('\Rp$total'),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                  height: 160.h,
                  width: 1000.w,
                  child: cartProvider.getCartList.isEmpty
                      ? Text('')
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green.shade700,
                              onPrimary: Colors.greenAccent),
                          onPressed: () {
                            if (cartProvider.getCartList.isNotEmpty) {
                              var uniqueKey =
                                  firestoreRef.collection('checkout').doc();
                              firestoreRef.collection('checkout').add({
                                'items': cartProvider.getCartList
                                    .map((c) => {
                                          'barcode': c.barcode,
                                          'name': c.name,
                                          'price': c.currentPrice,
                                          'qty': c.currentQty,
                                          'subtotal':
                                              c.currentPrice * c.currentQty,
                                        })
                                    .toList(),
                                'id': uniqueKey.id,
                                'name': customerId,
                                'date': date.text,
                                'cash': int.parse(_cash.text),
                                'change': change,
                                'total': total,
                              }).whenComplete(() {
                                showDoneDialog();
                                date.clear();
                                _cash.clear();
                                customerId = null;
                                change = null;
                                deleteAll();
                              });
                            }
                          },
                          child: Text(
                            'PROCEED',
                            style: TextStyle(
                                fontSize: 50.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
              SizedBox(
                height: 30.h,
              ),
            ],
          ))
        ],
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }

  void showDoneDialog() => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 300.h,
                ),
                SizedBox(
                    height: 200,
                    width: 400,
                    child: Lottie.asset('assets/success.json',
                        controller: controller, onLoaded: (composition) {
                      controller.duration = composition.duration;
                      controller.forward();
                    })),
                Text(
                  'The Transaction is Successful',
                  style:
                      TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 400.h,
                ),
              ],
            ),
          ));

  Future<void> deleteAll() async {
    final collection = await FirebaseFirestore.instance
        .collection("transaction")
        .doc('cart')
        .collection('detail cart')
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }

    return batch.commit();
  }
}
