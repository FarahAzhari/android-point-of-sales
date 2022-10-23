import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bintang_timur/dashboard/database/issue/map_issue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class issueItems extends StatefulWidget {
  const issueItems({Key? key}) : super(key: key);

  @override
  State<issueItems> createState() => _issueItemsState();
}

class _issueItemsState extends State<issueItems> {
  final date = TextEditingController();
  final barcode = TextEditingController();
  final name = TextEditingController();
  final costPrice = TextEditingController();
  final qty = TextEditingController();
  var supplierId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Issue Items',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  initializeOrder();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
                ))
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('supplier')
                    .orderBy('name')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return Container(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Expanded(
                      flex: 4,
                      child: DropdownButtonFormField(
                        value: supplierId,
                        isDense: true,
                        onChanged: (valueSelectedByUser) {
                          _showMessage(
                              'Selected Supplier is $valueSelectedByUser');
                          setState(() {
                            supplierId = valueSelectedByUser;
                          });
                        },
                        hint: Text('Choose Supplier'),
                        items: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          return DropdownMenuItem<String>(
                            value: document['name'],
                            child: Text(document['name']),
                          );
                        }).toList(),
                      ),
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
            SizedBox(height: 24.h),
            TextField(
              controller: barcode,
              textInputAction: TextInputAction.next,
              decoration: decoration('Barcode'),
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: name,
              textInputAction: TextInputAction.next,
              decoration: decoration('Name'),
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: costPrice,
              textInputAction: TextInputAction.next,
              decoration: decoration('Cost Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: qty,
              decoration: decoration('Qty'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              child: Text(
                'Create',
                style: TextStyle(fontSize: 50.sp),
              ),
              onPressed: () {
                final issue = Issue(
                  date: date.text,
                  barcode: barcode.text,
                  name: name.text,
                  costPrice: int.parse(costPrice.text),
                  qty: int.parse(qty.text),
                  supplierId: supplierId,
                );

                createIssue(issue).whenComplete(() {
                  setState(() {
                    date.clear();
                    barcode.clear();
                    name.clear();
                    costPrice.clear();
                    qty.clear();
                    supplierId = null;
                  });
                });
              },
            ),
          ],
        ),
      );
  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Future createIssue(Issue issue) async {
    try {
      //Reference to Document
      final docIssue = FirebaseFirestore.instance.collection('issue').doc();
      issue.id = docIssue.id;

      final json = issue.toJson();

      //Create document and write data to Firebase
      await docIssue
          .set(json)
          .then((value) => _showMessage("Issue Item Created"));
    } on FirebaseException catch (e) {
      print(e);
      _showMessage('$e');
    }
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }

  var barcodeIssue;
  var qtyIssue;
  getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("issue").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var doc = querySnapshot.docs[i];
      barcodeIssue = doc['barcode'];
      qtyIssue = doc['qty'];
      // print(barcodeIssue);
      // print(qtyIssue);
    }
  }

  Future<void> initializeOrder() async {
    await getDocs();
    return FirebaseFirestore.instance
        .collection('stock')
        .where('barcode', isEqualTo: barcodeIssue)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        var stockQty = element['qty'];
        var sub = stockQty - qtyIssue;
        try {
          FirebaseFirestore.instance.collection('stock').doc(element.id).set(
            {'qty': sub},
            SetOptions(merge: true),
          );
        } catch (error) {
          print(error);
        }
      });
    });
  }
}
