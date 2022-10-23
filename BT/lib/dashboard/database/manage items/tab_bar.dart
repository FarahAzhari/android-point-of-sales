import 'package:bintang_timur/dashboard/database/manage%20items/manage_issue.dart';
import 'package:bintang_timur/dashboard/database/manage%20items/manage_receive.dart';
import 'package:flutter/material.dart';

class tabBar extends StatefulWidget {
  const tabBar({Key? key}) : super(key: key);

  @override
  State<tabBar> createState() => _tabBarState();
}

class _tabBarState extends State<tabBar> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Manage Product'),
            centerTitle: true,
            bottom: TabBar(tabs: [
              Tab(
                text: 'Receive Items',
              ),
              Tab(
                text: 'Issue Items',
              ),
            ]),
          ),
          body: TabBarView(children: [
            manageReceive(),
            manageIssue(),
          ]),
        ),
      );
}
