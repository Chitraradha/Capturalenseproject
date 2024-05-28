import 'dart:developer';
import 'dart:io';

import 'package:captura_lens/about_us.dart';
import 'package:captura_lens/forgot_password.dart';
import 'package:captura_lens/services/admin_controller.dart';
import 'package:captura_lens/services/photographer_controller.dart';
import 'package:captura_lens/splash_screen.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../user/complaints_page.dart';
import '../help_page.dart';
import '../support_page.dart';

class PhotoProfile extends StatefulWidget {
  bool isPhoto;

  PhotoProfile({super.key, required this.isPhoto});

  @override
  State<PhotoProfile> createState() => _PhotoProfileState();
}

class _PhotoProfileState extends State<PhotoProfile> {
   

   final nameController= TextEditingController();
   final placeController =TextEditingController();
   final phoneNumber= TextEditingController();

  final List<Widget> _pages = <Widget>[
    const AboutUs(),
    const ForgotPassword(),
    const SupportPage(),
    const HelpPage(),
    const ComplaintsPage(),
  ];
  final List<String> _pagesname = [
    "AboutUs",
    "ForgotPasswor",
    "SupportPag",
    "HelpPag",
    "ComplaintsPag",
    "Logout"
  ];
  File? selectedImage;
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
 

 static Future<void> openMap() async {
  String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=10.7759,76.6651';
  try{
    // if (await canLaunch(googleUrl)) {
    // await launch(googleUrl, forceSafariVC: true);
    await launchUrl(Uri.parse(googleUrl));
  
  }catch(e){
    log('error map open$e');
  }  
}
 Future bottomsheet(String id) async {
      
 final photograperedit=Provider.of<PhotographerController>(context,listen: false);
      
    return showModalBottomSheet(
      
      context: context,
      builder: (context) {
        return Container(
          height: 500,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
               
              child: Column(
                children: [
                  SizedBox(height: 5,),
                   Container(
                    width: 50,
                    height: 5,
                    color: Colors.grey,
                   ),
                   SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     
                      Text('EDIT YOUR DETAILS ',style: TextStyle(fontSize: 20),),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'Name', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: placeController,
                    decoration: InputDecoration(
                        hintText: 'Place', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: phoneNumber,
                    decoration: InputDecoration(
                        hintText: 'phone number',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                   
                  SizedBox(
                    height: 60,
                  ),
                  GestureDetector(
                    onTap: () {
                       
                      photograperedit.updateprofile(id,{
                          'name':nameController.text,
                          'place':placeController.text,
                          'phonenumber':phoneNumber.text,
                           
                        } ).then(
                          (value) => Navigator.pop(context),
                        );
                        setState(() {
                          
                        });

                        // Map<String,dynamic> updateCompetitionid = 
                      // log('id the edit $id');
                      // Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<PhotographerController>(
            builder: (context, controller, child) {
          return FutureBuilder(
              future: controller.readPhotographerData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
                final userData = controller.currentUserData;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                   
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          // border: Border.all(color: Colors.white)
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                _pickImageFromGallery().then((value) async {
                                  SettableMetadata metadata = SettableMetadata(
                                      contentType: 'image/jpeg');
                                  final currenttime = TimeOfDay.now();
                                  UploadTask uploadTask = FirebaseStorage
                                      .instance
                                      .ref()
                                      .child("shopTagImage/Shop$currenttime")
                                      .putFile(selectedImage!, metadata);
                                  TaskSnapshot snapshot = await uploadTask;
                                  await snapshot.ref
                                      .getDownloadURL()
                                      .then((url) {
                                    FirebaseFirestore.instance
                                        .collection("Photographers")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({"profileUrl": url}).then(
                                            (value) => setState(() {}));
                                  });
                                });
                              },
                              child: Container(
                                width: 90,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: userData!.profileUrl.isNotEmpty
                                        ? DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                userData.profileUrl))
                                        : null),
                                child: userData.profileUrl.isEmpty
                                    ? const Center(child: Text("Photo"))
                                    : const SizedBox(),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                   
                                  children: [
                                    Text(
                                      userData.name,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 150,),
                                    TextButton(onPressed: (){
                                      bottomsheet(userData.id);

                                      nameController.text = userData.name.toString();
                                      placeController.text=userData.place.toString();
                                      phoneNumber.text=userData.phoneNumber.toString();
                                    }, child: Text('Edit Profile',style: TextStyle(color: Colors.blue,fontSize: 15),))
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  userData.typePhotographer,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // _launchgogglemap();
                                        openMap();
                                      },
                                      child: const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    
                                    Text(
                                      userData.place,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await _makePhoneCall(
                                            userData.phoneNumber.toString());
                                        log('click call');
                                      },
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      userData.phoneNumber.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            Expanded(
                              child: Column(
                                
                                children: [
                                  PopupMenuButton<int>(
                                    icon: const Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                    ),
                                    onSelected: (int index) {
                                      if (index == 5) {
                                        FirebaseAuth.instance
                                            .signOut()
                                            .then((value) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SplashScreen()),
                                                  (route) => false);
                                        });
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => _pages[
                                                index], // Use the selected index
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return List.generate(
                                        _pagesname.length,
                                        (index) => PopupMenuItem(
                                          value:
                                              index, // Set the value to the index
                                          child: Text(_pagesname[index]),
                                        ),
                                      ).toList();
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      FutureBuilder(
                          future: controller.readCurrentPhotoGrapherrPhotoa(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Expanded(child: SizedBox());
                            }
                            final postList = controller.currentUserPosts;
                            return postList.isEmpty
                                ? const Expanded(
                                    child: Center(
                                    child: Text(
                                      "No Post",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                                : Expanded(
                                    child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        itemCount: postList.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onLongPress: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0,
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            title:
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .black,
                                                                        shape: ContinuousRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                20))),
                                                                    onPressed:
                                                                        () {
                                                                      controller
                                                                          .deletePostByPG(postList[index]
                                                                              .postId)
                                                                          .then(
                                                                              (val) {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    )),
                                                          ));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          postList[index]
                                                              .imageUrl))),
                                            ),
                                          );
                                        }),
                                  );
                          })
                    ],
                  ),
                );
              });
        }),
      ),
    );
  }
}
