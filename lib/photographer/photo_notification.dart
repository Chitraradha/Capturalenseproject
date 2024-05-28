import 'dart:ui';

import 'package:captura_lens/services/photographer_controller.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PhotoNotification extends StatefulWidget {
  const PhotoNotification({super.key});

  @override
  State<PhotoNotification> createState() => _PhotoNotificationState();
}

class _PhotoNotificationState extends State<PhotoNotification> {
  Stream? bookingStream;

  getOnTheLoad() async {
    bookingStream = await PhotographerController().fetchAllNotification();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Notification',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: bookingStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? snapshot.data.docs.isEmpty
                    ? const Center(
                        child: Text(
                          "No Notifications",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          return Consumer<PhotographerController>(
                              builder: (context, controlelr, child) {
                            return FutureBuilder(
                                future: controlelr
                                    .fetchSelectedUSerData(ds["fromId"]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Text(
                                        "Loading",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }
                                  return ListTile(
                                    leading: controlelr
                                            .selecteduser!.profileUrl.isEmpty
                                        ? CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                controlelr
                                                    .selecteduser!.profileUrl),
                                          ),
                                    title: Text(
                                      "${ds["message"]} from ${controlelr.selecteduser!.name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  );
                                });
                          });
                        })
                : const Center(
                    child: Text(
                      "Loading...",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
          }),
    );
  }
}
