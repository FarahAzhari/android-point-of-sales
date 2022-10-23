import 'package:bintang_timur/dashboard/database/manage%20items/tab_bar.dart';
import 'package:bintang_timur/dashboard/database/receive/receive_items.dart';
import 'package:bintang_timur/dashboard/database/issue/issue_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bintang_timur/animations/FadeAnimation.dart';
import 'package:bintang_timur/dashboard/database/supplier/supplier.dart';
import 'package:bintang_timur/dashboard/database/customer/customer.dart';

class database extends StatefulWidget {
  const database({Key? key}) : super(key: key);

  @override
  State<database> createState() => _databaseState();
}

class _databaseState extends State<database> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database'),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => receiveItems()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/receive items.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Receive Items",
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => issueItems()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/issue items.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Issue Items",
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => tabBar()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/manage product.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Manage Product",
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => supplier()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/manage supplier.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Manage Supplier",
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
            1.5,
            Card(
              shadowColor: Colors.grey.shade100,
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => customer()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/manage customer.svg"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.w),
                        child: Text(
                          "Manage Customer",
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
        ],
      ),
    );
  }
}
