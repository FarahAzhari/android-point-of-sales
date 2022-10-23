import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bintang_timur/dashboard/database/supplier/add_supplier.dart';
import 'package:bintang_timur/dashboard/database/supplier/map_supplier.dart';

class supplier extends StatefulWidget {
  const supplier({Key? key}) : super(key: key);

  @override
  State<supplier> createState() => _supplierState();
}

class _supplierState extends State<supplier> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Manage Supplier'),
        ),
        body: StreamBuilder<List<Supplier>>(
          stream: readSupplier(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final supplierList = snapshot.data!;
              return ListView.builder(
                  itemCount: supplierList.length,
                  itemBuilder: (context, index) {
                    final supplier = supplierList[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 56.w, vertical: 16.h),
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(supplier.name,
                              style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.bold)),
                          Text(supplier.address)
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 15.h),
                          Text(supplier.email),
                          Text(supplier.phone),
                        ],
                      ),
                      onTap: () {
                        name.text = supplier.name;
                        email.text = supplier.email;
                        phone.text = supplier.phone;
                        address.text = supplier.address;
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
                                          TextField(
                                            controller: name,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration:
                                                decoration('Supplier Name'),
                                          ),
                                          SizedBox(height: 24.h),
                                          TextField(
                                            controller: email,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: decoration('Email'),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                          SizedBox(height: 24.h),
                                          TextField(
                                            controller: phone,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration:
                                                decoration('Phone Number'),
                                            keyboardType: TextInputType.phone,
                                          ),
                                          SizedBox(height: 24.h),
                                          TextField(
                                            controller: address,
                                            decoration: decoration('Address'),
                                          ),
                                          SizedBox(height: 32.h),
                                          ElevatedButton(
                                              child: Text(
                                                'Update',
                                                style:
                                                    TextStyle(fontSize: 50.sp),
                                              ),
                                              onPressed: () {
                                                final docSupplier =
                                                    FirebaseFirestore.instance
                                                        .collection('supplier')
                                                        .doc(supplier.id);

                                                docSupplier.update({
                                                  'name': name.text,
                                                  'email': email.text,
                                                  'phone': phone.text,
                                                  'address': address.text,
                                                }).whenComplete(() {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    _showMessage(
                                                        'Supplier Updated');
                                                  });
                                                });
                                              }),
                                          SizedBox(height: 20.h),
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
                                                final docSupplier =
                                                    FirebaseFirestore.instance
                                                        .collection('supplier')
                                                        .doc(supplier.id);
                                                docSupplier
                                                    .delete()
                                                    .whenComplete(() {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    _showMessage(
                                                        'Supplier Deleted');
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addsupplier()),
            );
          },
        ),
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Stream<List<Supplier>> readSupplier() => FirebaseFirestore.instance
      .collection('supplier')
      .orderBy('name')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Supplier.fromJson(doc.data())).toList());

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }
}
