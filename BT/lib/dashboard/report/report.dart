import 'package:bintang_timur/dashboard/report/inventory/model_inventory_report.dart';
import 'package:bintang_timur/dashboard/report/issue/model_issue_report.dart';
import 'package:bintang_timur/dashboard/report/purchase/model_purchase_report.dart';
import 'package:bintang_timur/dashboard/report/issue/pdf_issue_api.dart';
import 'package:bintang_timur/dashboard/report/purchase/pdf_purchase_api.dart';
import 'package:bintang_timur/dashboard/report/inventory/pdf_inventory_api.dart';
import 'package:bintang_timur/dashboard/report/pdf_api.dart';
import 'package:bintang_timur/dashboard/report/sales/model_sales_report.dart';
import 'package:bintang_timur/dashboard/report/sales/pdf_sales_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bintang_timur/animations/FadeAnimation.dart';

class report extends StatefulWidget {
  const report({Key? key}) : super(key: key);

  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  var item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF8F8F8),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 56.w, vertical: 102.h),
        children: [
          FadeAnimation(
            1,
            Card(
              shadowColor: Colors.grey.shade100,
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () async {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection("receive")
                      .orderBy('date')
                      .get();
                  final content = ContentP(receive: [
                    for (var i = 0; i < querySnapshot.docs.length; i++)
                      Receive(
                          date: querySnapshot.docs[i]['date'],
                          barcode: querySnapshot.docs[i]['barcode'],
                          name: querySnapshot.docs[i]['name'],
                          costPrice: querySnapshot.docs[i]['costPrice'],
                          sellingPrice: querySnapshot.docs[i]['sellingPrice'],
                          qty: querySnapshot.docs[i]['qty'],
                          supplierId: querySnapshot.docs[i]['dropdownSupplier'])
                  ]);

                  final pdfFile = await PdfPurchaseApi.generate(content);
                  PdfApi.openFile(pdfFile);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/purchase report.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Purchase Report",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 64.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 102.h),
          FadeAnimation(
            1.2,
            Card(
              shadowColor: Colors.grey.shade100,
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () async {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection("issue")
                      .orderBy('date')
                      .get();
                  final content = Content(issue: [
                    for (var i = 0; i < querySnapshot.docs.length; i++)
                      Issue(
                          date: querySnapshot.docs[i]['date'],
                          barcode: querySnapshot.docs[i]['barcode'],
                          name: querySnapshot.docs[i]['name'],
                          costPrice: querySnapshot.docs[i]['costPrice'],
                          qty: querySnapshot.docs[i]['qty'],
                          supplierId: querySnapshot.docs[i]['dropdownSupplier'])
                  ]);

                  final pdfFile = await PdfIssueApi.generate(content);
                  PdfApi.openFile(pdfFile);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/issue report.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Issue Report",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 64.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 102.h),
          FadeAnimation(
            1.3,
            Card(
              shadowColor: Colors.grey.shade100,
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () async {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection("stock")
                      .orderBy('date')
                      .get();
                  final content = ContentI(inventory: [
                    for (var i = 0; i < querySnapshot.docs.length; i++)
                      Inventory(
                        date: querySnapshot.docs[i]['date'],
                        barcode: querySnapshot.docs[i]['barcode'],
                        name: querySnapshot.docs[i]['name'],
                        sellingPrice: querySnapshot.docs[i]['sellingPrice'],
                        qty: querySnapshot.docs[i]['qty'],
                      )
                  ]);

                  final pdfFile = await PdfInventoryApi.generate(content);
                  PdfApi.openFile(pdfFile);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/inventory report.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Inventory Report",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 64.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 102.h),
          FadeAnimation(
            1.4,
            Card(
              shadowColor: Colors.grey.shade100,
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () async {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection("checkout")
                      .orderBy('date')
                      .get();
                  final content = ContentS(sales: [
                    for (var i = 0; i < querySnapshot.docs.length; i++)
                      for (var a = 0; a < 1; a++)
                        Sales(
                            date: querySnapshot.docs[i]['date'],
                            name: querySnapshot.docs[i]['name'],
                            cash: querySnapshot.docs[i]['cash'],
                            change: querySnapshot.docs[i]['change'],
                            total: querySnapshot.docs[i]['total'],
                            barcode: querySnapshot.docs[i]['items'][a]
                                ['barcode'],
                            nameItem: querySnapshot.docs[i]['items'][a]['name'],
                            price: querySnapshot.docs[i]['items'][a]['price'],
                            qty: querySnapshot.docs[i]['items'][a]['qty'],
                            subtotal: querySnapshot.docs[i]['items'][a]
                                ['subtotal']
                            )
                  ]);

                  final pdfFile = await PdfSalesApi.generate(content);
                  PdfApi.openFile(pdfFile);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/sales report.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Sales Report",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 64.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 102.h),
        ],
      ),
    );
  }
}
