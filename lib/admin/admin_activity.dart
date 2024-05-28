import 'package:captura_lens/admin/admin_complaints_view.dart';
import 'package:captura_lens/admin/admin_photo_view.dart';
import 'package:captura_lens/admin/admin_request_view.dart';
import 'package:captura_lens/admin/admin_user_view.dart';
import 'package:captura_lens/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminActivity extends StatefulWidget {
  const AdminActivity({super.key});

  @override
  State<AdminActivity> createState() => _AdminActivityState();
}

class _AdminActivityState extends State<AdminActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            color: Colors.black,
            height: 300,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminComplaintsVIew()));
                      },
                      child: Container(
                        color: CustomColors.buttonGrey,
                        height: 120,
                        width: 120,
                        child: const Center(child: Text("Complaints",  style: TextStyle(color: Colors.black),)),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminRequestView()));
                      },
                      child: Container(
                        color: CustomColors.buttonGrey,
                        height: 120,
                        width: 120,
                        child: const Center(child: Text("Requests",  style: TextStyle(color: Colors.black),)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminUserView()));
                      },
                      child: Container(
                        color: CustomColors.buttonGrey,
                        height: 120,
                        width: 120,
                        child: const Center(child: Text("User",  style: TextStyle(color: Colors.black),)),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminPhotoView()));
                      },
                      child: Container(
                        color: CustomColors.buttonGrey,
                        height: 120,
                        width: 120,
                        child: const Center(child: Text("Photographer", style: TextStyle(color: Colors.black),)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
