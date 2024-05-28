import 'package:captura_lens/services/user_controller.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({super.key});

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  Stream? bookingStream;

  getOnTheLoad() async {
    bookingStream = await UserController().fetchAllNotification();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
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
                          return Consumer<UserController>(
                              builder: (context, controlelr, child) {
                            return FutureBuilder(
                                future:
                                    controlelr.fetchSelectedPhotoGraphererData(
                                        ds["fromId"]),
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
                                    leading: ds["fromId"] == adminuid
                                        ? const SizedBox()
                                        : controlelr.selectedpGData!.profileUrl
                                                .isEmpty
                                            ? const CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    controlelr.selectedpGData!
                                                        .profileUrl),
                                              ),
                                    title: Text(
                                      "${ds["fromId"] != adminuid ? controlelr.selectedpGData!.name : ""} ${ds["message"]}",
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
                      "Loading",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
          }),
    );
  }
}
