import 'package:captura_lens/photographer/photo_event_details.dart';
import 'package:captura_lens/services/photographer_controller.dart';
import 'package:captura_lens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PhotoHomeDetails extends StatefulWidget {
  const PhotoHomeDetails({super.key});

  @override
  State<PhotoHomeDetails> createState() => _PhotoHomeDetailsState();
}

class _PhotoHomeDetailsState extends State<PhotoHomeDetails> {
  Stream? competitionStream;

  getOnTheLoad() async {
    competitionStream = await PhotographerController().getCompetitionDetails();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final serchController = Provider.of<PhotographerController>(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      serchController.fetchAllCompetitionForSearch();
                    },
                    onChanged: (value) {
                      serchController.searchCompetition(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(CupertinoIcons.search),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // IconButton(
                //   icon: const Icon(
                //     Icons.power_settings_new_rounded,
                //     color: Color.fromARGB(255, 229, 43, 30),
                //   ),
                //   onPressed: () {
                //     FirebaseAuth.instance.signOut().then((value) {
                //       Navigator.of(context).pushAndRemoveUntil(
                //           MaterialPageRoute(
                //               builder: (context) => SplashScreen()),
                //           (route) => false);
                //     });
                //   },
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: serchController.searchResult.isNotEmpty
                  ? ListView.builder(
                      itemCount: serchController.searchResult.length,
                      itemBuilder: (context, index) {
                        final list = serchController.searchResult;
                        return InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => PhotoEventDetails(
                            //               ds: ds,
                            //             )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          color: Colors.grey,
                                          width: size.width * .3,
                                          // height: size.height * .18,
                                          child: Image.network(
                                              list[index].imageURL)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        list[index].payment == false
                                            ? "Free"
                                            : "Paid",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: list[index].payment == false
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index].title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          list[index].prizeAndDescription,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Deadline : ${list[index].deadline}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Place : ${list[index].place}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : StreamBuilder(
                      stream: competitionStream,
                      builder: (context, AsyncSnapshot snapshot) {
                        return snapshot.hasData
                            ? snapshot.data.docs.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No Events",
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot ds =
                                          snapshot.data.docs[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PhotoEventDetails(
                                                        ds: ds,
                                                      )));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      color: Colors.grey,
                                                      width: size.width * .3,
                                                      // height: size.height * .18,
                                                      child: ds.exists
                                                          ? Image.network(
                                                              ds["imageURL"],
                                                            )
                                                          : const Center(
                                                              child: Text(
                                                                  "Photo")),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      ds["payment"] == false
                                                          ? "Free"
                                                          : "Paid",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              ds["payment"] ==
                                                                      false
                                                                  ? Colors.green
                                                                  : Colors.red),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        ds["title"],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        ds["prizeAndDescription"],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        "Deadline : ${ds["deadline"]}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        "Place : ${ds["place"]}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                            : const Center(
                                child: Text("Loading .."),
                              );
                      }),
              // child: InkWell(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const PhotoEventDetails()));
              //     },
              //     child: allCompetitionDetails()),
            ),
          )
        ],
      ),
    );
  }
}
