import 'package:captura_lens/services/admin_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPhotoView extends StatefulWidget {
  const AdminPhotoView({super.key});

  @override
  State<AdminPhotoView> createState() => _AdminPhotoViewState();
}

class _AdminPhotoViewState extends State<AdminPhotoView> {
  Stream? photoStream;

  getOnTheLoad() async {
    photoStream = await AdminController().getPhotographerDetails();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allPhotographerDetails() {
    return StreamBuilder(
        stream: photoStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? snapshot.data.docs.isEmpty
                  ? Center(
                      child: Text(
                        "No Photographers",
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
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 30,
                                    backgroundImage: ds["profileUrl"].isEmpty
                                        ? null
                                        : NetworkImage(ds["profileUrl"]),
                                  ),
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
                                      Text(
                                        ds["phoneNumber"].toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        ds["place"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        ds["typePhotographer"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // ElevatedButton(
                                  //   onPressed: () {},
                                  //   style: ElevatedButton.styleFrom(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 12, horizontal: 40),
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(10)),
                                  //       foregroundColor: Colors.black,
                                  //       backgroundColor: Colors.white),
                                  //   child: const Text(
                                  //     "Accepted",
                                  //     style: TextStyle(color: Colors.black),
                                  //   ),
                                  // ),

                                  ElevatedButton(
                                    onPressed: () async {
                                      AdminController()
                                          .deletePGPost(ds["id"])
                                          .then((v) {
                                        AdminController()
                                            .deletePG(ds["id"])
                                            .then((value) {
                                          setState(() {});
                                        });
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white),
                                    child: const Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
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
                  "View Photographers",
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
            Expanded(child: allPhotographerDetails()),
          ],
        ),
      ),
    );
  }
}
