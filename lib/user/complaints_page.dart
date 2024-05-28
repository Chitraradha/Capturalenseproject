import 'package:captura_lens/model/complaint_model.dart';
import 'package:captura_lens/model/notification_model.dart';
import 'package:captura_lens/photographer/photo_profile.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

import '../constants.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController complaintsController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: CupertinoColors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: CupertinoColors.black,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'We are very Sorry to have an issue with you',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is required";
                          } else {
                            return null;
                          }
                        },
                        controller: complaintsController,
                        decoration: const InputDecoration(
                          hintText: 'Type your Complaints',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is required";
                          } else {
                            return null;
                          }
                        },
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Name',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is required";
                          } else {
                            return null;
                          }
                        },
                        controller: phoneController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10)
                        ],
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            UserController()
                                .registerComplaint(ComplaintModel(
                                    status: "Registerd",
                                    complaint: complaintsController.text,
                                    name: nameController.text,
                                    phoneNumber: phoneController.text,
                                    uid:
                                        FirebaseAuth.instance.currentUser!.uid))
                                .then((compaitId) {
                              UserController().sendNotificationtouser(
                                  NotificationModel(
                                      date: date,
                                      fromId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      type: "User",
                                      message:
                                          "${nameController.text}\nComplaint: ${complaintsController.text}",
                                      time: time,
                                      toId: adminuid));
                            }).then((value) {
                              Fluttertoast.showToast(
                                  msg: "Complaint Registered",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              complaintsController.clear();
                              nameController.clear();
                              phoneController.clear();
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.buttonGreen,
                            foregroundColor: Colors.white),
                        child: const Text("Submit"),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
