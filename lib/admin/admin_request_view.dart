import 'dart:async';

import 'package:captura_lens/services/admin_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminRequestView extends StatefulWidget {
  const AdminRequestView({Key? key}) : super(key: key);

  @override
  State<AdminRequestView> createState() => _AdminRequestViewState();
}

class _AdminRequestViewState extends State<AdminRequestView> {
  Stream<QuerySnapshot>? request;

  Future<void> getRequest() async {
    request = await AdminController().getRequestView();
    setState(() {
      
    });
  }

  @override
  void initState()  {
     
    super.initState();
    getRequest();
  }

Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget allRequest() {
    return StreamBuilder<QuerySnapshot>(
      stream: request ?? Stream.empty(),
      initialData: null,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
         
        return snapshot.hasData
            ? snapshot.data!.docs.isEmpty
                ? const Center(
                    child: Text(
                      "No Request",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.white),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                 
                                SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds['name'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    
                                    
                                    SizedBox(height: 5),
                                     
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                          IconButton(onPressed: (){
                                        
                                        }, icon: Icon(Icons.email,color: Colors.white,)),
                                        Text(
                                          ds['email'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        IconButton(onPressed: (){
                                         _makePhoneCall(ds['contactNumber'].toString());
                                        }, icon: Icon(Icons.phone,color: Colors.white,)),
                                        Text(
                                          ds['contactNumber'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: [
                          //       ElevatedButton(
                          //         onPressed: () {},
                          //         style: ElevatedButton.styleFrom(
                          //           padding: const EdgeInsets.symmetric(
                          //               vertical: 12, horizontal: 40),
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(10)),
                          //           foregroundColor: Colors.black,
                          //           backgroundColor: Colors.white,
                          //         ),
                          //         child: const Text(
                          //           "Accept",
                          //           style: TextStyle(color: Colors.black),
                          //         ),
                          //       ),
                          //       ElevatedButton(
                          //         onPressed: () {},
                          //         style: ElevatedButton.styleFrom(
                          //           padding: const EdgeInsets.symmetric(
                          //               vertical: 12, horizontal: 40),
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(10)),
                          //           foregroundColor: Colors.black,
                          //           backgroundColor: Colors.white,
                          //         ),
                          //         child: const Text(
                          //           "Reject",
                          //           style: TextStyle(color: Colors.black),
                          //         ),
                          //       )
                          //     ],
                          //   )
                          ],
                        ),
                      );
                    },
                  )
            : Container(child: Text('lastcontainer'),);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "View Requests",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: allRequest()),
          ],
        ),
      ),
    );
  }
}
