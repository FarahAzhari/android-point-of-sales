import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bintang_timur/dashboard/database/supplier/map_supplier.dart';
import 'package:bintang_timur/widget/utils.dart';
import 'package:bintang_timur/main.dart';

class addsupplier extends StatefulWidget {
  const addsupplier({Key? key}) : super(key: key);

  @override
  State<addsupplier> createState() => _addsupplierState();
}

class _addsupplierState extends State<addsupplier> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

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
            'Add Supplier',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: name,
              textInputAction: TextInputAction.next,
              decoration: decoration('Supplier Name'),
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: email,
              textInputAction: TextInputAction.next,
              decoration: decoration('Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: phone,
              textInputAction: TextInputAction.next,
              decoration: decoration('Phone Number'),
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
                'Create',
                style: TextStyle(fontSize: 50.sp),
              ),
              onPressed: () {
                final supplier = Supplier(
                  name: name.text,
                  email: email.text,
                  phone: phone.text,
                  address: address.text,
                );

                createSupplier(supplier);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Future createSupplier(Supplier supplier) async {
    try {
      //Reference to Document
      final docSupplier =
          FirebaseFirestore.instance.collection('supplier').doc();
      supplier.id = docSupplier.id;

      final json = supplier.toJson();

      //Create document and write data to Firebase
      await docSupplier
          .set(json)
          .then((value) => _showMessage("Supplier Created"));
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
}
