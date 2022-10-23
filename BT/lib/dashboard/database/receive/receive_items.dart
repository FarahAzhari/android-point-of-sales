import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class receiveItems extends StatefulWidget {
  const receiveItems({Key? key}) : super(key: key);

  @override
  State<receiveItems> createState() => _receiveItemsState();
}

class _receiveItemsState extends State<receiveItems> {
  final date = TextEditingController();
  final barcode = TextEditingController();
  final name = TextEditingController();
  final costPrice = TextEditingController();
  final sellingPrice = TextEditingController();
  final qty = TextEditingController();
  String imageName = "";
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  FirebaseStorage storageRef = FirebaseStorage.instance;
  var supplierId;

  imagepicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
      });
    }
  }

  _create() async {
    var uniqueKey = firestoreRef.collection('receive').doc();
    String uploadFileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference =
        storageRef.ref().child("receive").child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath!.path));
    uploadTask.snapshotEvents.listen((event) {
      print(event.bytesTransferred.toString() +
          "\t" +
          event.totalBytes.toString());
    });

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

      if (uploadPath.isNotEmpty) {
        firestoreRef.collection('receive').doc(uniqueKey.id).set({
          'id': uniqueKey.id,
          'dropdownSupplier': supplierId,
          'date': date.text,
          'barcode': barcode.text,
          'name': name.text,
          'costPrice': int.parse(costPrice.text),
          'sellingPrice': int.parse(sellingPrice.text),
          'qty': int.parse(qty.text),
          'imageUrl': uploadPath,
        }).then((value) => _showMessage("Receive Item Created"));

        var uniqueKeyy = FirebaseFirestore.instance.collection('stock').doc();
        CollectionReference stock =
            FirebaseFirestore.instance.collection('stock');
        stock.doc(uniqueKeyy.id).set({
          'id': uniqueKeyy.id,
          'date': date.text,
          'barcode': barcode.text,
          'name': name.text,
          'sellingPrice': int.parse(sellingPrice.text),
          'qty': int.parse(qty.text),
          'imageUrl': uploadPath,
        });
      } else {
        _showMessage("Something While Uploading Image");
      }
      setState(() {
        date.clear();
        barcode.clear();
        name.clear();
        costPrice.clear();
        sellingPrice.clear();
        qty.clear();
        imagePath = null;
        imageName = "";
        supplierId = null;
      });
    });
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }

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
            'Receive Items',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: firestoreRef
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
              controller: sellingPrice,
              textInputAction: TextInputAction.next,
              decoration: decoration('Selling Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: qty,
              decoration: decoration('Qty'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      imagepicker();
                    },
                    child: CircleAvatar(
                      radius: 100.r,
                      backgroundImage: imagePath == null
                          ? NetworkImage('null')
                          : FileImage(File(imagePath!.path)) as ImageProvider,
                      child: Center(child: Icon(Icons.add_a_photo)),
                    ),
                  ),
                  SizedBox(width: 30.w),
                  imageName == ""
                      ? Container()
                      : Text(
                          "${imageName}",
                          style: TextStyle(fontSize: 30.sp),
                        ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              child: Text(
                'Create',
                style: TextStyle(fontSize: 50.sp),
              ),
              onPressed: () {
                _create();
              },
            ),
          ],
        ),
      );
  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );
}
