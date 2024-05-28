import 'package:captura_lens/constants.dart';
import 'package:captura_lens/user/user_activity.dart';
import 'package:captura_lens/user/user_home_details.dart';
import 'package:captura_lens/user/user_notification.dart';
import 'package:captura_lens/user/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

  int _selectIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
     UserHomeDetails(),
    const UserActivity(),
    const UserNotification(),
      UserProfile()
  ];

  void _onItemTapped (int index){
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.black,
      body: Container(
        child: _widgetOptions.elementAt(_selectIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.buttonGrey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey,),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.view_comfy_alt_sharp, color: Colors.grey,),
              label: 'Activity'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.notifications, color: Colors.grey,),
              label: 'Notifications'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.grey,),
              label: 'Profile'
          )
        ],
        currentIndex: _selectIndex,
        selectedItemColor: Colors.black12,
        selectedLabelStyle: TextStyle(color: Colors.black),
        onTap: _onItemTapped,
      ),
    );
  }
}
