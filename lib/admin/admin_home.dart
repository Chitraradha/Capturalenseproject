import 'package:captura_lens/admin/admin_activity.dart';
import 'package:captura_lens/admin/admin_event_post.dart';
import 'package:captura_lens/admin/admin_home_details.dart';
import 'package:captura_lens/admin/admin_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const AdminHomeDetails(),
    const AdminEventPost(),
    const AdminNotification(),
    const AdminActivity()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.buttonGrey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: 'Post'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.view_comfy_alt_sharp,
                color: Colors.black,
              ),
              label: 'Activity'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black12,
        onTap: _onItemTapped,
        showSelectedLabels: false,
      ),
    );
  }
}
