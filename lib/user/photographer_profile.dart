import 'dart:developer';

import 'package:captura_lens/services/admin_controller.dart';
import 'package:captura_lens/services/photographer_controller.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotographerProfile extends StatefulWidget {
  String pGId;
  // bool isPhoto;

  PhotographerProfile({super.key, required this.pGId});

  @override
  State<PhotographerProfile> createState() => _PhotographerProfileState();
}

class _PhotographerProfileState extends State<PhotographerProfile> {
  String _countryCodeController = '+91';

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void openwhatsapp(String phonenumber, String text) async {
    // const phonenumber = '+919497504365';
    var url =
        'https://api.whatsapp.com/send?phone=$phonenumber/&text=${Uri.encodeComponent(text)}';
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('coulnd note open whastapp$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<UserController>(
          builder: (context, controller, child) {
            return FutureBuilder(
              future: controller.fetchSelectedPhotoGraphererData(widget.pGId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }

                final userData = controller.selectedpGData;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: size.width * .35,
                              height: size.height * .16,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: userData!.profileUrl.isNotEmpty
                                      ? DecorationImage(
                                          fit: BoxFit.fill,
                                          image:
                                              NetworkImage(userData.profileUrl))
                                      : null),
                              child: userData.profileUrl.isEmpty
                                  ? const Center(child: Text("Photo"))
                                  : const SizedBox(),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  userData.typePhotographer,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      userData.place,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await _makePhoneCall(
                                            userData.phoneNumber.toString());
                                      },
                                      child: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      userData.phoneNumber.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Spacer(),
                            // Expanded(
                            //   child: Column(
                            //     children: [
                            //       PopupMenuButton<int>(
                            //         icon: const Icon(
                            //           Icons.menu,
                            //           color: Colors.white,
                            //         ),
                            //         onSelected: (int index) {
                            //           if (index == 5) {
                            //             FirebaseAuth.instance
                            //                 .signOut()
                            //                 .then((value) {
                            //               Navigator.of(context)
                            //                   .pushAndRemoveUntil(
                            //                       MaterialPageRoute(
                            //                           builder: (context) =>
                            //                               const SplashScreen()),
                            //                       (route) => false);
                            //             });
                            //           } else {
                            //             Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                 builder: (context) => _pages[
                            //                     index], // Use the selected index
                            //               ),
                            //             );
                            //           }
                            //         },
                            //         itemBuilder: (BuildContext context) {
                            //           return List.generate(
                            //             _pagesname.length,
                            //             (index) => PopupMenuItem(
                            //               value:
                            //                   index, // Set the value to the index
                            //               child: Text(_pagesname[index]),
                            //             ),
                            //           ).toList();
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FutureBuilder(
                        future: controller
                            .readselectedPhotoGrapherrPhotos(widget.pGId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Expanded(child: SizedBox());
                          }
                          final postList = controller.selectedPgPhotos;
                          return postList.isEmpty
                              ? const Expanded(
                                  child: Center(
                                  child: Text("No Post"),
                                ))
                              : Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                    ),
                                    itemCount: postList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              postList[index].imageUrl,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FloatingActionButton(
                          onPressed: () async {
                            openwhatsapp(userData.phoneNumber.toString(),
                                userData.typePhotographer);
                          },
                          child: Image.asset(
                            'assets/download.jpeg',
                            width: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     //  userData
        //     openwhatsapp();
        //   },
        //   child: Image.asset(
        //     'assets/download.jpeg',
        //     width: 50,
        //   ),
        // ),
      ),
    );
  }
}
