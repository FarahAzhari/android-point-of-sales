import 'package:bintang_timur/dashboard/pos/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bintang_timur/dashboard/pos/counter_provider.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class pos extends StatefulWidget {
  const pos({Key? key}) : super(key: key);

  @override
  State<pos> createState() => _posState();
}

class _posState extends State<pos> {
  final search = TextEditingController();
  final date = TextEditingController();
  final barcode = TextEditingController();
  final name = TextEditingController();
  final sellingPrice = TextEditingController();
  final qty = TextEditingController();
  String nameSearch = '';
  CollectionReference ref = FirebaseFirestore.instance.collection('stock');
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final _counter = Provider.of<Counter>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Point of Sale'),
        centerTitle: true,
        actions: <Widget>[
          Center(
            child: IconButton(
              icon: Icon(
                Icons.shopping_bag,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => cart()),
                );
              },
            ),
          ),
          SizedBox(
            width: 60.w,
          )
        ],
      ),
      body: StreamBuilder(
        stream: ref.orderBy('name').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: TextField(
                    controller: search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search Item',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.r),
                          borderSide: const BorderSide(color: Colors.blue)),
                    ),
                    onChanged: (val) {
                      setState(() {
                        nameSearch = val;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        if (nameSearch.isEmpty) {
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 56.w, vertical: 10.h),
                            leading: CircleAvatar(
                              radius: 100.r,
                              backgroundImage: NetworkImage(doc['imageUrl']),
                            ),
                            title: Text(doc['name'],
                                style: TextStyle(
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc['barcode']),
                                Text(
                                  'Price: Rp' + doc['sellingPrice'].toString(),
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text(
                                  'Qty: ' + doc['qty'].toString(),
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.add_circle),
                              color: Colors.black,
                              onPressed: () {
                                var uniqueKey = firestoreRef
                                    .collection('transaction')
                                    .doc();

                                firestoreRef
                                    .collection('transaction')
                                    .doc('cart')
                                    .collection('detail cart')
                                    .doc(uniqueKey.id)
                                    .set({
                                  'id': uniqueKey.id,
                                  'barcode': doc['barcode'],
                                  'name': doc['name'],
                                  'qty': doc['qty'],
                                  'currentQty': _counter.value,
                                  'currentPrice': doc['sellingPrice'],
                                  'price': doc['sellingPrice']
                                });
                              },
                            ),
                            onTap: (() {
                              date.text = doc['date'];
                              barcode.text = doc['barcode'];
                              name.text = doc['name'];
                              sellingPrice.text =
                                  doc['sellingPrice'].toString();
                              qty.text = doc['qty'].toString();
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.all(8.0),
                                              children: [
                                                DateTimeField(
                                                    controller: date,
                                                    decoration:
                                                        decoration('Date'),
                                                    format: DateFormat(
                                                        "dd-MM-yyyy"),
                                                    onShowPicker: (context,
                                                            currentValue) =>
                                                        showDatePicker(
                                                            context: context,
                                                            firstDate:
                                                                DateTime(2000),
                                                            lastDate:
                                                                DateTime(2025),
                                                            initialDate:
                                                                currentValue ??
                                                                    DateTime
                                                                        .now())),
                                                SizedBox(height: 24.h),
                                                TextField(
                                                  controller: barcode,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      decoration('Barcode'),
                                                ),
                                                SizedBox(height: 24.h),
                                                TextField(
                                                  controller: name,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      decoration('Name'),
                                                ),
                                                SizedBox(height: 24.h),
                                                TextField(
                                                  controller: sellingPrice,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: decoration(
                                                      'Selling Price'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(height: 24.h),
                                                TextField(
                                                  controller: qty,
                                                  decoration: decoration('Qty'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(height: 32.h),
                                                ElevatedButton(
                                                    child: Text(
                                                      'Update',
                                                      style: TextStyle(
                                                          fontSize: 50.sp),
                                                    ),
                                                    onPressed: () {
                                                      snapshot.data!.docs[index]
                                                          .reference
                                                          .update({
                                                        'date': date.text,
                                                        'name': name.text,
                                                        'barcode': barcode.text,
                                                        'sellingPrice':
                                                            int.parse(
                                                                sellingPrice
                                                                    .text),
                                                        'qty':
                                                            int.parse(qty.text),
                                                      }).whenComplete(() {
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
                                                          _showMessage(
                                                              'Stock Updated');
                                                        });
                                                      });
                                                    }),
                                                ElevatedButton(
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          fontSize: 50.sp),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      snapshot.data!.docs[index]
                                                          .reference
                                                          .delete()
                                                          .whenComplete(() {
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
                                                          _showMessage(
                                                              'Item Deleted');
                                                        });
                                                      });
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                            }),
                          );
                        }
                        if (doc['name']
                            .toString()
                            .toLowerCase()
                            .startsWith(nameSearch.toLowerCase())) {
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 56.w, vertical: 10.h),
                            leading: CircleAvatar(
                              radius: 100.r,
                              backgroundImage: NetworkImage(doc['imageUrl']),
                            ),
                            title: Text(doc['name'],
                                style: TextStyle(
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc['barcode']),
                                Text(
                                  'Sell: Rp' + doc['sellingPrice'].toString(),
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text(
                                  'Qty: ' + doc['qty'].toString(),
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.add_circle),
                              color: Colors.black,
                              onPressed: () {
                                var uniqueKey = firestoreRef
                                    .collection('transaction')
                                    .doc();

                                firestoreRef
                                    .collection('transaction')
                                    .doc('cart')
                                    .collection('detail cart')
                                    .doc(uniqueKey.id)
                                    .set({
                                  'id': uniqueKey.id,
                                  'barcode': doc['barcode'],
                                  'name': doc['name'],
                                  'qty': doc['qty'],
                                  'currentQty': _counter.value,
                                  'currentPrice': doc['sellingPrice'],
                                  'price': doc['sellingPrice']
                                });
                              },
                            ),
                            onTap: (() {
                              date.text = doc['date'];
                              barcode.text = doc['barcode'];
                              name.text = doc['name'];
                              sellingPrice.text =
                                  doc['sellingPrice'].toString();
                              qty.text = doc['qty'].toString();
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.all(8.0),
                                              children: [
                                                DateTimeField(
                                                    controller: date,
                                                    decoration:
                                                        decoration('Date'),
                                                    format: DateFormat(
                                                        "dd-MM-yyyy"),
                                                    onShowPicker: (context,
                                                            currentValue) =>
                                                        showDatePicker(
                                                            context: context,
                                                            firstDate:
                                                                DateTime(2000),
                                                            lastDate:
                                                                DateTime(2025),
                                                            initialDate:
                                                                currentValue ??
                                                                    DateTime
                                                                        .now())),
                                                SizedBox(height: 24.h),
                                                TextField(
                                                  controller: barcode,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      decoration('Barcode'),
                                                ),
                                                SizedBox(height: 24.h),
                                                TextField(
                                                  controller: name,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      decoration('Name'),
                                                ),
                                                SizedBox(height: 24.h),
                                                TextField(
                                                  controller: sellingPrice,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: decoration(
                                                      'Selling Price'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(height: 24.h),
                                                TextField(
                                                  controller: qty,
                                                  decoration: decoration('Qty'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(height: 32.h),
                                                ElevatedButton(
                                                    child: Text(
                                                      'Update',
                                                      style: TextStyle(
                                                          fontSize: 50.sp),
                                                    ),
                                                    onPressed: () {
                                                      snapshot.data!.docs[index]
                                                          .reference
                                                          .update({
                                                        'date': date.text,
                                                        'name': name.text,
                                                        'barcode': barcode.text,
                                                        'sellingPrice':
                                                            int.parse(
                                                                sellingPrice
                                                                    .text),
                                                        'qty':
                                                            int.parse(qty.text),
                                                      }).whenComplete(() {
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
                                                          _showMessage(
                                                              'Stock Updated');
                                                        });
                                                      });
                                                    }),
                                                ElevatedButton(
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          fontSize: 50.sp),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      snapshot.data!.docs[index]
                                                          .reference
                                                          .delete()
                                                          .whenComplete(() {
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
                                                          _showMessage(
                                                              'Item Deleted');
                                                        });
                                                      });
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                            }),
                          );
                        }
                        return Container();
                      }),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
}
