 
 
import 'package:captura_lens/services/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserActivity extends StatefulWidget {
  const UserActivity({super.key});

  @override
  State<UserActivity> createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivity> {
  bool showDetails = false;
  @override
  Widget build(BuildContext context) {
    final searchController = Provider.of<UserController>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      searchController.fetchCurrentuserBookingEvents();
                    },
                    onChanged: (value) {
                      searchController.serchBookingByEventName(value);
                    },
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
            const SizedBox(
              height: 20,
            ),
            Consumer<UserController>(builder: (context, controller, child) {
              return Expanded(
                child: FutureBuilder(
                    future: controller.fetchCurrentuserBookingEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      final list = searchController.searchBooking.isEmpty
                          ? controller.mybookingList
                          : searchController.searchBooking;
                      return list.isEmpty
                          ? const Center(
                              child: Text(
                                "No activities",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 20,
                                  ),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: FutureBuilder(
                                      future: controller
                                          .fetchSelectedPhotoGraphererData(
                                              list[index].photographerId),
                                      builder: (context, snap) {
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: Text(
                                              "Loading...",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
                                        final pgData =
                                            controller.selectedpGData;
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                pgData!.profileUrl.isEmpty
                                                    ? const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.grey,
                                                        radius: 50,
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .profile_circled,
                                                          size: 40,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            Colors.grey,
                                                        radius: 50,
                                                        backgroundImage:
                                                            NetworkImage(pgData
                                                                .profileUrl),
                                                      ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 10,),
                                                    Text(
                                                      pgData.name,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.phone,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          pgData.phoneNumber
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      list[index]
                                                          .photographyType,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          list[index].status ==
                                                                  "Requested"
                                                              ? list[index]
                                                                  .status
                                                              : "Booking ${list[index].status}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 18,
                                                              color: colorPicker(
                                                                  list[index]
                                                                      .status),),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: 200,
                                                          child: ListTile(
                                                            onTap: () {
                                                              setState(() {
                                                                showDetails =
                                                                    !showDetails;
                                                              });
                                                            },
                                                            title: const Text(
                                                              "Event Details",
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          163,
                                                                          163,
                                                                          163)),
                                                            ),
                                                            trailing: Icon(showDetails
                                                                ? Icons
                                                                    .arrow_drop_up_rounded
                                                                : Icons
                                                                    .arrow_drop_down_rounded),
                                                          ),
                                                        ),
                                                        showDetails
                                                            ? Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Event : ${list[index].eventName}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  Text(
                                                                    "Address : ${list[index].address}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "From : ${list[index].from}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                      Text(
                                                                        "  To : ${list[index].to}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // Text(
                                                                  //   "Duration : ${list[index].hours.toString()} hours",
                                                                  //   style: const TextStyle(
                                                                  //       color:
                                                                  //           Colors.white),
                                                                  // ),
                                                                ],
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    )

                                                    // Text(
                                                    //   list[index].name,
                                                    //   style: const TextStyle(
                                                    //       color:
                                                    //           Colors.white),
                                                    // ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        );
                                      }),
                                );
                              });
                    }),
              );
            })
          ],
        ),
      ),
    );
  }
}

colorPicker(status) {
  switch (status) {
    case "Requested":
      {
        return Colors.green;
      }
    case "Accepted":
      {
        return Colors.green;
      }
    case "Rejected":
      {
        return Colors.red;
      }
  }
}
