import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bintang_timur/dashboard/database/customer/add_customer.dart';
import 'package:bintang_timur/dashboard/database/customer/map_customer.dart';

class customer extends StatefulWidget {
  const customer({Key? key}) : super(key: key);

  @override
  State<customer> createState() => _customerState();
}

class _customerState extends State<customer> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Manage Customer'),
        ),
        body: StreamBuilder<List<Customer>>(
          stream: readCustomer(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final customerList = snapshot.data!;
              return ListView.builder(
                  itemCount: customerList.length,
                  itemBuilder: (context, index) {
                    final customer = customerList[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 56.w, vertical: 16.h),
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customer.name,
                              style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 15.h),
                          Text(customer.email),
                          Text(customer.phone),
                        ],
                      ),
                      onTap: () {
                        name.text = customer.name;
                        email.text = customer.email;
                        phone.text = customer.phone;
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
                                                decoration('Customer Name'),
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
                                            decoration:
                                                decoration('Phone Number'),
                                            keyboardType: TextInputType.phone,
                                          ),
                                          SizedBox(height: 32.h),
                                          ElevatedButton(
                                              child: Text(
                                                'Update',
                                                style:
                                                    TextStyle(fontSize: 50.sp),
                                              ),
                                              onPressed: () {
                                                final docCustomer =
                                                    FirebaseFirestore.instance
                                                        .collection('customer')
                                                        .doc(customer.id);

                                                docCustomer.update({
                                                  'name': name.text,
                                                  'email': email.text,
                                                  'phone': phone.text,
                                                }).whenComplete(() {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    _showMessage(
                                                        'Customer Updated');
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
                                                final docCustomer =
                                                    FirebaseFirestore.instance
                                                        .collection('customer')
                                                        .doc(customer.id);
                                                docCustomer
                                                    .delete()
                                                    .whenComplete(() {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    _showMessage(
                                                        'Customer Deleted');
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
              MaterialPageRoute(builder: (context) => addcustomer()),
            );
          },
        ),
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Stream<List<Customer>> readCustomer() => FirebaseFirestore.instance
      .collection('customer')
      .orderBy('name')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Customer.fromJson(doc.data())).toList());

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }
}
