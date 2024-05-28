import 'package:captura_lens/model/booking_model.dart';
import 'package:captura_lens/model/notification_model.dart';
import 'package:captura_lens/model/photographer_model.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:captura_lens/user/user_categories.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class UserEventBooking extends StatefulWidget {
  PhotographerModel photographerModel;
  UserEventBooking({super.key, required this.photographerModel});

  @override
  State<UserEventBooking> createState() => _UserEventBookingState();
}

class _UserEventBookingState extends State<UserEventBooking> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var contactController = TextEditingController();
  var _formkey = GlobalKey<FormState>();


  final int maxlenght =10;

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context, int item) async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (_selectedDate != null) {
      if (item == 1) {
        setState(() {
          fromDateController.text = _selectedDate.toString().split(" ")[0];
        });
      } else {
        setState(() {
          toDateController.text = _selectedDate.toString().split(" ")[0];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: CupertinoColors.white,
        ),
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
                        Text(
                          'Book Your Event',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: CupertinoColors.white),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          hintText: 'Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      controller: addressController,
                      decoration: const InputDecoration(
                          hintText: 'Address', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      controller: eventNameController,
                      decoration: const InputDecoration(
                          hintText: 'Event Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      onTap: () {
                        _selectDate(context, 1);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      controller: fromDateController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: 'From Date',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      onTap: () {
                        _selectDate(context, 2);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      controller: toDateController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: 'To Date',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      inputFormatters: [LengthLimitingTextInputFormatter(maxlenght)],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      controller: contactController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Contact Number',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Consumer<UserController>(
                    //   builder: (context, controller, child) {
                    //     return Container(
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(5),
                    //           border: Border.all(
                    //             color: Color.fromARGB(255, 74, 74, 74),
                    //           )),
                    //       child: Row(
                    //         children: [
                    //           IconButton(
                    //               onPressed: () {
                    //                 controller.lessHours();
                    //               },
                    //               icon: const Icon(
                    //                   CupertinoIcons.lessthan_circle)),
                    //           Text(
                    //             "${controller.hours} hours",
                    //             style: const TextStyle(
                    //                 color: Color.fromARGB(255, 119, 118, 118),
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //           const Expanded(child: SizedBox()),
                    //           IconButton(
                    //               onPressed: () {
                    //                 controller.addHour();
                    //               },
                    //               icon: const Icon(
                    //                   CupertinoIcons.greaterthan_circle)),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),
                    const SizedBox(
                      height: 20,
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
                          if (_formkey.currentState!.validate()) {
                            UserController()
                                .bookNewEventbyUSer(BookingModel(
                                    status: "Requested",
                                    address: addressController.text,
                                    eventName: eventNameController.text,
                                    from: fromDateController.text,
                                    // hours: Provider.of<UserController>(context,
                                    //         listen: false)
                                    //     .hours,
                                    name: nameController.text,
                                    photographerId: widget.photographerModel.id,
                                    photographyType: widget
                                        .photographerModel.typePhotographer,
                                    to: toDateController.text,
                                    uid:
                                        FirebaseAuth.instance.currentUser!.uid,
                                        number: contactController.text,
                                    
                                        ))
                                .then((value) {
                              UserController().sendNotificationtouser(
                                  NotificationModel(
                                      type: "User",
                                      date: date,
                                      fromId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      message:
                                          "You have received a new booking request",
                                      time: time,
                                      toId: widget.photographerModel.id));
                            }).then((value) {
                              Fluttertoast.showToast(
                                  msg: "Booking is Successfull",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              nameController.clear();
                              addressController.clear();
                              eventNameController.clear();
                              fromDateController.clear();
                              toDateController.clear();
                              contactController.clear();
                              Navigator.of(context).pop();
                            });
                          }
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => UserCategories()));
                        },
                        child: const Text('Book'),
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
