import 'package:captura_lens/constants.dart';
import 'package:captura_lens/photographer/photo_event_registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PhotoEventDetails extends StatefulWidget {
  DocumentSnapshot ds;
  PhotoEventDetails({super.key, required this.ds});

  @override
  State<PhotoEventDetails> createState() => _PhotoEventDetailsState();
}

class _PhotoEventDetailsState extends State<PhotoEventDetails> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width,
                height: size.height * .3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.ds["imageURL"])),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.ds["title"].toString().toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Details of the contest",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                child: Text(
                  "${widget.ds["title"].toString().toUpperCase()}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: widget.ds["prizeAndDescription"],
                  style: const TextStyle(
                      color: CupertinoColors.white, fontSize: 15),
                )
              ])),
              const SizedBox(
                height: 30,
              ),
              Align(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                 PhotoEventRegistration(competitionId:widget.ds["id"] ,payemtMode: widget.ds["payment"],paybleAmount: widget.ds["registrationfee"],upiId: widget.ds["upiId"],)));
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: CustomColors.buttonGrey),
                  child: const Text(
                    "Participate",
                    style: TextStyle(
                      color: CustomColors.buttonTextGrey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
