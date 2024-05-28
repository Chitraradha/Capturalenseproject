// import 'dart:async';
// import 'package:captura_lens/to_do_admin_model.dart';
// import 'package:captura_lens/try_to_do.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// class AdminController{
//   final db=FirebaseFirestore.instance;

//   login({required String emailAddress,required String password,context}) async {
//     try {

//       await  FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: emailAddress,
//           password: password
//       ).then((value)  {
//         print(emailAddress);
//         print(password);
//         });
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       }
//     }
//   }

//   // Future addEventData(AdminModel obj,context)async{
//   //   final doc = db.collection("Upload Event").doc();
//   //   doc.set(obj.tojson(doc.id)).then((value) {Navigator.push(context, MaterialPageRoute(builder: (context)=>Homeone()));});

//   // }
//   Future<AdminModel?>readRegisteredSingleEventData()async{
//     final snapshot=await db.collection("Competition").doc("94MQ567Yj0").get();
//     if(snapshot.exists){
//       return AdminModel.fromjson(snapshot.data()!);
//     }
//     return null;
//   }
//   List<AdminModel > list=[];
//   Future <List<AdminModel>> fetchAllEvents()async{

//     QuerySnapshot<Map<String, dynamic>> snapshot= await db.collection("Upload Event").get();

//     list= snapshot.docs.map((singleSnapshot){
//       return  AdminModel.fromjson(singleSnapshot.data());
//     } ).toList();
//     return list;
//   }

// }