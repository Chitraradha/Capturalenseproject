import 'package:captura_lens/model/notification_model.dart';
import 'package:captura_lens/services/photographer_controller.dart';
import 'package:captura_lens/user/user_activity.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoActivity extends StatefulWidget {
  const PhotoActivity({super.key});

  @override
  State<PhotoActivity> createState() => _PhotoActivityState();
}

class _PhotoActivityState extends State<PhotoActivity> {
  Stream? bookingStream;

  getOnTheLoad() async {
    bookingStream = await PhotographerController().getBookingDetails();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allBookingDetails() {
    return StreamBuilder(
        stream: bookingStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? snapshot.data.docs.isEmpty
                  ? const Center(
                      child: Text(
                        "Booking not found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Consumer<PhotographerController>(
                              builder: (context, controller, child) {
                            return FutureBuilder(
                                future:
                                    controller.fetchSelectedUSerData(ds["uid"]),
                                builder: (context, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Text(
                                        "Loading ...",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }
                                  final userdata = controller.selecteduser;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ds["photographyType"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // userdata!.profileUrl.isEmpty
                                            // ? const CircleAvatar(
                                            //     backgroundColor: Colors.grey,
                                            //     radius: 30,
                                            //     child: Icon(
                                            //       CupertinoIcons
                                            //           .profile_circled,
                                            //       color: Colors.black,
                                            //       size: 50,
                                            //     ),
                                            //   )
                                            // : CircleAvatar(
                                            //     backgroundColor: Colors.grey,
                                            //     radius: 30,
                                            //     backgroundImage: NetworkImage(
                                            //         userdata.profileUrl),
                                            //   ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ds["name"],
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                      _makePhoneCall(ds['number'].toString());
                                                      },
                                                      child: const Icon(
                                                        Icons.phone,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      ds['number']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  ds["eventName"],
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "From : ${ds["from"]}",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      "To : ${ds["to"]}",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                // Text(
                                                //   "Time Duration : ${ds["hours"].toString()} hours",
                                                //   style: const TextStyle(
                                                //       color: Colors.white),
                                                // ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ds["status"] == "Requested"
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                 
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      PhotographerController()
                                                          .updateEventStatus(
                                                              "Accepted",
                                                              ds["bookingId"])
                                                          .then((value) {
                                                        PhotographerController()
                                                            .sendNotificationtouser(
                                                          NotificationModel(
                                                            type:
                                                                "Photographer",
                                                            date: date,
                                                            fromId: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            message:
                                                                "Accepetd your booking",
                                                            time: time,
                                                            toId: ds["uid"],
                                                          ),
                                                        );
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12,
                                                                    horizontal:
                                                                        40),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                10,
                                                              ),
                                                            ),
                                                            foregroundColor:
                                                                Colors.black,
                                                            backgroundColor:
                                                                Colors.white),
                                                    child: const Text(
                                                      "Accept",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      PhotographerController()
                                                          .updateEventStatus(
                                                              "Rejected",
                                                              ds["bookingId"])
                                                          .then((value) {
                                                        PhotographerController()
                                                            .sendNotificationtouser(NotificationModel(
                                                                type:
                                                                    "Photographer",
                                                                date: date,
                                                                fromId: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                                message:
                                                                    "Rejected your booking",
                                                                time: time,
                                                                toId:
                                                                    ds["uid"]));
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12,
                                                          horizontal: 40),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      foregroundColor:
                                                          Colors.black,
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                    child: const Text(
                                                      "Reject",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Text(
                                                ds["status"],
                                                style: TextStyle(
                                                  color: colorPicker(
                                                    ds["status"],
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                        );
                      })
              : Container();
        });
  }
Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Booking",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
            Expanded(child: allBookingDetails())
          ],
        ),
      ),
    );
  }
}
