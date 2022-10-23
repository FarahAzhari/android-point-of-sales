import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bintang_timur/dashboard/database/issue/map_issue.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class manageIssue extends StatefulWidget {
  const manageIssue({Key? key}) : super(key: key);

  @override
  State<manageIssue> createState() => _manageIssueState();
}

class _manageIssueState extends State<manageIssue> {
  final date = TextEditingController();
  final barcode = TextEditingController();
  final name = TextEditingController();
  final costPrice = TextEditingController();
  final qty = TextEditingController();
  var supplierId;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<List<Issue>>(
          stream: readIssue(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final issueList = snapshot.data!;
              return ListView.builder(
                  itemCount: issueList.length,
                  itemBuilder: (context, index) {
                    final issue = issueList[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 56.w),
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 45.h),
                          Text(issue.date,
                              style: TextStyle(color: Colors.blue)),
                          Text(issue.supplierId),
                        ],
                      ),
                      title: Text(issue.name,
                          style: TextStyle(
                              fontSize: 45.sp, fontWeight: FontWeight.bold)),
                      subtitle: Text(issue.barcode),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 45.h),
                          Text('Cost: ${issue.costPrice}',
                              style: TextStyle(color: Colors.red)),
                          Text('Qty: ${issue.qty}',
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      onTap: () {
                        date.text = issue.date;
                        name.text = issue.name;
                        barcode.text = issue.barcode;
                        costPrice.text = '${issue.costPrice}';
                        qty.text = '${issue.qty}';
                        supplierId = issue.supplierId;
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
                                                final docIssue =
                                                    FirebaseFirestore.instance
                                                        .collection('issue')
                                                        .doc(issue.id);

                                                docIssue.update({
                                                  'date': date.text,
                                                  'name': name.text,
                                                  'barcode': barcode.text,
                                                  'costPrice':
                                                      int.parse(costPrice.text),
                                                  'qty': int.parse(qty.text),
                                                  'dropdownSupplier':
                                                      supplierId,
                                                }).whenComplete(() {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    _showMessage(
                                                        'Issue Updated');
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
                                                final docIssue =
                                                    FirebaseFirestore.instance
                                                        .collection('issue')
                                                        .doc(issue.id);
                                                docIssue
                                                    .delete()
                                                    .whenComplete(() {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    _showMessage(
                                                        'Issue Deleted');
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

  Stream<List<Issue>> readIssue() => FirebaseFirestore.instance
      .collection('issue')
      .orderBy('date')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Issue.fromJson(doc.data())).toList());

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }
}
