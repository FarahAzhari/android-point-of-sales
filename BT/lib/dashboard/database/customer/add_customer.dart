import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bintang_timur/dashboard/database/customer/map_customer.dart';
import 'package:bintang_timur/widget/utils.dart';
import 'package:bintang_timur/main.dart';

class addcustomer extends StatefulWidget {
  const addcustomer({Key? key}) : super(key: key);

  @override
  State<addcustomer> createState() => _addcustomerState();
}

class _addcustomerState extends State<addcustomer> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

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
            'Add Customer',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: name,
              textInputAction: TextInputAction.next,
              decoration: decoration('Customer Name'),
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
              decoration: decoration('Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              child: Text(
                'Create',
                style: TextStyle(fontSize: 50.sp),
              ),
              onPressed: () {
                final customer = Customer(
                  name: name.text,
                  email: email.text,
                  phone: phone.text,
                );

                createCustomer(customer);

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

  Future createCustomer(Customer customer) async {
    try {
      //Reference to Document
      final docCustomer =
          FirebaseFirestore.instance.collection('customer').doc();
      customer.id = docCustomer.id;

      final json = customer.toJson();

      //Create document and write data to Firebase
      await docCustomer
          .set(json)
          .then((value) => _showMessage("Customer Created"));
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
