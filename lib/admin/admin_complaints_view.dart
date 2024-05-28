import 'package:captura_lens/model/notification_model.dart';
import 'package:captura_lens/services/admin_controller.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AdminComplaintsVIew extends StatefulWidget {
  const AdminComplaintsVIew({super.key});

  @override
  State<AdminComplaintsVIew> createState() => _AdminComplaintsVIewState();
}

class _AdminComplaintsVIewState extends State<AdminComplaintsVIew> {
  Stream? complaintsStream;

  getOnTheLoad() async {
    complaintsStream = await AdminController().getComplaintsDetails();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
    setState(() {
      
    });
  }

  Widget allComplaintDetails() {
    return StreamBuilder(
        stream: complaintsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? snapshot.data.docs.isEmpty
                  ? const Center(
                      child: Text(
                        "No Complaints",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Consumer<AdminController>(
                                  builder: (context, controller, child) {
                                return FutureBuilder(
                                    future: controller
                                        .fetchSelectedUSerData(ds["uid"]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: Text(
                                            "Loading...",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                      }
                                      //final uData = controller.selecteduser;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // uData!.profileUrl.isEmpty
                                          //     ? const CircleAvatar(
                                          //         backgroundColor: Colors.grey,
                                          //         radius: 30,
                                          //         child: Icon(
                                          //           CupertinoIcons
                                          //               .profile_circled,
                                          //           color: Colors.white,
                                          //           size: 50,
                                          //         ),
                                          //       )
                                          //     : CircleAvatar(
                                          //         backgroundColor: Colors.grey,
                                          //         radius: 30,
                                          //         backgroundImage: NetworkImage(
                                          //             uData.profileUrl),
                                          //       ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ds["complaint"],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                ds["name"],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                ds["phoneNumber"],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (ds["status"] == "Requested") {
                                        AdminController()
                                            .updateComplaintStatus(
                                                "Accepted", ds["complaintId"])
                                            .then((value) {
                                          AdminController().sendNotificationtouser(
                                              NotificationModel(
                                                  date: date,
                                                  fromId: FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  type: "Admin",
                                                  message:
                                                      "Complaint type : ${ds["type"]}\nThank you for your feedback,our team is noticed your issue by raising the complaint.it will solve as soon as possible ",
                                                  time: time,
                                                  toId: ds["uid"]));
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        foregroundColor: Colors.black,
                                        backgroundColor:
                                            ds["status"] == "Accepted" ||
                                                    ds["status"] == "Solved"
                                                ? Colors.black
                                                : Colors.white),
                                    child: Text(
                                      "Accept",
                                      style: TextStyle(
                                          color: ds["status"] == "Accepted" ||
                                                  ds["status"] == "Solved"
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                  ds["status"] == "Accepted" ||
                                          ds["status"] == "Solved"
                                      ? ElevatedButton(
                                          onPressed: () {
                                            if (ds["status"] == "Accepted") {
                                              AdminController()
                                                  .updateComplaintStatus(
                                                      "Solved",
                                                      ds["complaintId"])
                                                  .then((value) {
                                                AdminController()
                                                    .sendNotificationtouser(
                                                        NotificationModel(
                                                            date: date,
                                                            fromId: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            type: "Admin",
                                                            message:
                                                                "Hi,( Complaint type : ${ds["type"]} ) your complaint is solved",
                                                            time: time,
                                                            toId: ds["uid"]));
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 40),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              foregroundColor: Colors.black,
                                              backgroundColor:
                                                  ds["status"] == "Solved"
                                                      ? Colors.transparent
                                                      : Colors.white),
                                          child: Text(
                                            "Mark as Solved",
                                            style: TextStyle(
                                                color: ds["status"] == "Solved"
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        )
                                      // ignore: prefer_const_constructors
                                      : SizedBox()
                                ],
                              )
                            ],
                          ),
                        );
                      })
              : Container();
        });
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "View Complaints",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: allComplaintDetails()),
          ],
        ),
      ),
    );
  }
}
