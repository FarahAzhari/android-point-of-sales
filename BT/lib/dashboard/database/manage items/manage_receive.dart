import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class manageReceive extends StatefulWidget {
  const manageReceive({Key? key}) : super(key: key);

  @override
  State<manageReceive> createState() => _manageReceiveState();
}

class _manageReceiveState extends State<manageReceive> {
  final date = TextEditingController();
  final barcode = TextEditingController();
  final name = TextEditingController();
  final costPrice = TextEditingController();
  final sellingPrice = TextEditingController();
  final qty = TextEditingController();
  var supplierId;
  CollectionReference ref = FirebaseFirestore.instance.collection('receive');

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: ref.orderBy('date').snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 56.w, vertical: 10.h),
                      leading: Image.network(
                        doc['imageUrl'],
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['date'],
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text(doc['name'],
                              style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc['barcode']),
                          Text(doc['dropdownSupplier']),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Cost: Rp' + doc['costPrice'].toString(),
                            style: TextStyle(color: Colors.red),
                          ),
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
                      onTap: () {
                        supplierId = doc['dropdownSupplier'];
                        date.text = doc['date'];
                        barcode.text = doc['barcode'];
                        name.text = doc['name'];
                        costPrice.text = doc['costPrice'].toString();
                        sellingPrice.text = doc['sellingPrice'].toString();
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
                                          StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('supplier')
                                                  .orderBy('name')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );

                                                return Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 16.0),
                                                  child: Expanded(
                                                    flex: 4,
                                                    child:
                                                        DropdownButtonFormField(
                                                      value: supplierId,
                                                      isDense: true,
                                                      onChanged:
                                                          (valueSelectedByUser) {
                                                        setState(() {
                                                          supplierId =
                                                              valueSelectedByUser;
                                                        });
                                                      },
                                                      hint: Text(
                                                          'Choose Supplier'),
                                                      items: snapshot.data!.docs
                                                          .map((DocumentSnapshot
                                                              document) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value:
                                                              document['name'],
                                                          child: Text(
                                                              document['name']),
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
                                              onShowPicker: (context,
                                                      currentValue) =>
                                                  showDatePicker(
                                                      context: context,
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2025),
                                                      initialDate:
                                                          currentValue ??
                                                              DateTime.now())),
                                          SizedBox(height: 24.h),
                                          TextField(
                                            controller: barcode,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: decoration('Barcode'),
                                          ),
                                          SizedBox(height: 24.h),
                                          TextField(
                                            controller: name,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: decoration('Name'),
                                          ),
                                          SizedBox(height: 24.h),
                                          TextField(
                                            controller: costPrice,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration:
                                                decoration('Cost Price'),
                                            keyboardType: TextInputType.number,
                                          ),
                                          SizedBox(height: 24.h),
                                          TextField(
                                            controller: sellingPrice,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration:
                                                decoration('Selling Price'),
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
                                                'Update',
                                                style:
                                                    TextStyle(fontSize: 50.sp),
                                              ),
                                              onPressed: () {
                                                snapshot
                                                    .data!.docs[index].reference
                                                    .update({
                                                  'date': date.text,
                                                  'name': name.text,
                                                  'barcode': barcode.text,
                                                  'costPrice':
                                                      int.parse(costPrice.text),
                                                  'sellingPrice': int.parse(
                                                      sellingPrice.text),
                                                  'qty': int.parse(qty.text),
                                                  'dropdownSupplier':
                                                      supplierId,
                                                }).whenComplete(() {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    _showMessage(
                                                        'Receive Updated');
                                                  });
                                                });
                                              }),
                                          ElevatedButton(
                                              child: Text(
                                                'Delete',
                                                style:
                                                    TextStyle(fontSize: 50.sp),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.red),
                                              ),
                                              onPressed: () {
                                                snapshot
                                                    .data!.docs[index].reference
                                                    .delete()
                                                    .whenComplete(() {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    _showMessage(
                                                        'Receive Deleted');
                                                  });
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      },
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
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
