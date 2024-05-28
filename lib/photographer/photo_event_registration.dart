import 'package:captura_lens/constants.dart';
import 'package:captura_lens/model/notification_model.dart';
import 'package:captura_lens/model/register_competition_model.dart';
import 'package:captura_lens/photographer/photo_event_payment.dart';
import 'package:captura_lens/photographer/photo_login_signup.dart';
import 'package:captura_lens/services/photographer_controller.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoEventRegistration extends StatefulWidget {
  String competitionId;
  double paybleAmount;
  bool payemtMode;
  String upiId;
  PhotoEventRegistration(
      {super.key,
      required this.competitionId,
      required this.upiId,
      required this.payemtMode,
      required this.paybleAmount});

  @override
  State<PhotoEventRegistration> createState() => _PhotoEventRegistrationState();
}

class _PhotoEventRegistrationState extends State<PhotoEventRegistration> {
  final name = TextEditingController();
  final email = TextEditingController();
  final contactNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CupertinoColors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: CupertinoColors.black,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Register Yourself',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Complete the form below to get start',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: CustomColors.buttonGreen,
                          ),
                          hintText: 'Name',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: CustomColors.buttonGreen,
                          ),
                          hintText: 'Email Address',
                          border: OutlineInputBorder()),
                    ),
                    // const SizedBox(height: 20.0),
                    // const TextField(
                    //   decoration: InputDecoration(
                    //       hintText: 'Password',
                    //       prefixIcon: Icon(
                    //         Icons.lock_outline,
                    //         color: CustomColors.buttonGreen,
                    //       ),
                    //       border: OutlineInputBorder()),
                    //   obscureText: true,
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: contactNumber,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: CustomColors.buttonGreen,
                          ),
                          hintText: 'Contact Number',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            foregroundColor: Colors.white,
                            backgroundColor: CustomColors.buttonGreen),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.payemtMode == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoEventPayment(
                                    amount: widget.paybleAmount,
                                    upiId: widget.upiId,
                                    registerCompetitionModel:
                                        RegisterCompetitionModel(
                                            competitionId: widget.competitionId,
                                            contactNumber: contactNumber.text,
                                            name: name.text,
                                            email: email.text,
                                            payment: widget.payemtMode,
                                            uid: FirebaseAuth
                                                .instance.currentUser!.uid),
                                    regId:
                                        FirebaseAuth.instance.currentUser!.uid +
                                            widget.competitionId,
                                  ),
                                ),
                              );
                            } else {
                              PhotographerController()
                                  .registerCompetition(
                                      FirebaseAuth.instance.currentUser!.uid +
                                          widget.competitionId,
                                      RegisterCompetitionModel(
                                          competitionId: widget.competitionId,
                                          contactNumber: contactNumber.text,
                                          name: name.text,
                                          email: email.text,
                                          payment: widget.payemtMode,
                                          uid: FirebaseAuth
                                              .instance.currentUser!.uid))
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Registration completed")));
                                PhotographerController().sendNotificationtouser(
                                    NotificationModel(
                                        date: date,
                                        fromId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        type: "Photographer",
                                        message:
                                            "has registered for the competition",
                                        time: time,
                                        toId: adminuid));
                                Navigator.of(context).pop();
                              });
                            }
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
