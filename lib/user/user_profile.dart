import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:captura_lens/about_us.dart';
import 'package:captura_lens/change_password.dart';
import 'package:captura_lens/user/complaints_page.dart';
import 'package:captura_lens/help_page.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:captura_lens/splash_screen.dart';
import 'package:captura_lens/support_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? selectedImage;

  String imageURL = '';
  Uint8List? _image;
  dynamic editedImage;
  final firebaseStorage = FirebaseStorage.instance;
  String uniqueImageName = DateTime.now().microsecondsSinceEpoch.toString();

  Future<File?> _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage != null) {
      setState(() {
        _image = File(returnImage.path).readAsBytesSync();
        selectedImage = File(returnImage.path);
      });
    }
    return selectedImage;
  }

  Future<File?> _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage != null) {
      setState(() {
        _image = File(returnImage.path).readAsBytesSync();
        selectedImage = File(returnImage.path);
      });
    }
    return selectedImage;
  }

  Future bottomsheet() async {
    return showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (context) => Container(
        height: 200,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await _pickImageFromGallery();
                  },
                  icon: Icon(
                    Icons.image,
                    size: 60,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () async {
                    await _pickImageFromCamera();
                  },
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 60,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      if (_image != null) {
                        _pickImageFromGallery().then(
                          (value) async {
                            SettableMetadata metadata =
                                SettableMetadata(contentType: 'image/jpeg');
                            final currenttime = TimeOfDay.now();
                            UploadTask uploadTask = FirebaseStorage.instance
                                .ref()
                                .child("shopTagImage/Shop$currenttime")
                                .putFile(selectedImage!, metadata);
                            TaskSnapshot snapshot = await uploadTask;
                            await snapshot.ref.getDownloadURL().then(
                              (url) {
                                FirebaseFirestore.instance
                                    .collection("User")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"profileUrl": url}).then(
                                        (value) => setState(() {}));
                              },
                            );
                          },
                        );
                      }
                    } catch (e) {
                      log('error $e');
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Save'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Consumer<UserController>(builder: (context, controller, child) {
            return Stack(
              children: [
                Container(
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        image:  
                             DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/horizontal-lines-photography-4-1.webp'),
                              )
                            ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                            future: controller.fetchCurrentUserData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 90,
                                  ),
                                  controller.currentUserData!.profileUrl.isEmpty
                                      ? IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.image_sharp,
                                            size: 50,
                                            color: Colors.white,
                                          ))
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              controller
                                                  .currentUserData!.profileUrl),
                                        ),
                                  Text(
                                    controller.currentUserData!.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              );
                            }),
                      ],
                    )),
                Positioned(
                  top: w * .28,
                  left: w * .55,
                  child: Container(
                    alignment: Alignment.center,
                    width: w * .080,
                    height: h * .070,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: IconButton(
                        onPressed: () async {
                          await bottomsheet();
                        },
                        icon: Icon(Icons.camera_alt_outlined)),
                  ),
                )
              ],
            );
          }),
          Container(
            color: Colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AboutUs()));
                        },
                        child: const Text("About Us")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SupportPage()));
                        },
                        child: const Text("Support")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HelpPage()));
                        },
                        child: const Text("Help")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePassword()));
                        },
                        child: const Text("Change Password")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ComplaintsPage(),
                            ),
                          );
                        },
                        child: const Text("Complains")),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then(
                          (value) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const SplashScreen()),
                                (route) => false);
                          },
                        );
                      },
                      child: const Row(
                        children: [Icon(Icons.logout), Text("Log Out")],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
