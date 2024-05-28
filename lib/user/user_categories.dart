import 'dart:developer';

import 'package:captura_lens/photographer/photo_profile.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:captura_lens/user/photographer_profile.dart';
import 'package:captura_lens/user/user_event_booking.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCategories extends StatefulWidget {
  String type;

 
   
  UserCategories({super.key, required this.type, });

  @override
  State<UserCategories> createState() => _UserCategoriesState();
}

class _UserCategoriesState extends State<UserCategories> {
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
      backgroundColor: CupertinoColors.black,
      appBar: AppBar(
        backgroundColor: CupertinoColors.black,
        leading: const Icon(
          CupertinoIcons.arrow_left,
          color: Colors.white,
        ),
      ),
      body: Consumer<UserController>(builder: (context, controller, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.search,
                          color: CupertinoColors.black,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('assets/ acti.jpg'), 
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Where every click tells you a tale of forever: \n your love, our lense, timeless memmories",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
                child: FutureBuilder(
                    future: controller.sortPhotographersByType(widget.type),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      final data = controller.sortList;
                      return data.isEmpty
                          ? const Center(
                              child: Text(
                                "Users not found in this category",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    height: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            data[index].profileUrl.isEmpty
                                                ? const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    radius: 30,
                                                    child: Icon(Icons
                                                        .person_off_outlined),
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    radius: 60,
                                                    backgroundImage:
                                                        NetworkImage(data[index]
                                                            .profileUrl),
                                                  ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 14.0),
                                                  child: Text(
                                                    data[index].name,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                          await _makePhoneCall(
                                                              data[index]
                                                                  .phoneNumber
                                                                  .toString());
                                                        },
                                                        icon: Icon(
                                                          Icons.phone,
                                                          color: Colors.white,
                                                        )),
                                                    Text(
                                                      data[index]
                                                          .phoneNumber
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                           
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: Colors.white,
                                                        )),
                                                    Text(
                                                      data[index].place,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PhotographerProfile(
                                                              pGId: data[index]
                                                                  .id,
                                                            )));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 40),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  foregroundColor: Colors.black,
                                                  backgroundColor:
                                                      Colors.white),
                                              child: const Text(
                                                "View Work",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserEventBooking(
                                                              photographerModel:
                                                                  data[index],
                                                            )));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 40),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  foregroundColor: Colors.black,
                                                  backgroundColor:
                                                      Colors.white),
                                              child: const Text(
                                                "Booking",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                    }))
          ],
        );
      }),
    );
  }
}
