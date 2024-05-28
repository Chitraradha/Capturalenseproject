import 'dart:async';

import 'package:captura_lens/model/add_competition_model.dart';
import 'package:captura_lens/model/notification_model.dart';
import 'package:captura_lens/model/user_model.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminController with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  Future addAdminCompetition(
      AddCompetitionModel addEventModel, String id) async {
    return await FirebaseFirestore.instance
        .collection("Competition")
        .doc(id)
        .set(addEventModel.toJson());
  }

  Future<Stream<QuerySnapshot>> getPhotographerDetails() async {
    return FirebaseFirestore.instance.collection("Photographers").snapshots();
  }


  // 
   Future deleteevent( id) async {
    return db.collection("Competition").doc(id).delete();
  }


  

   //update
   Future updateCompetition(id,Map<String,dynamic> updateCompetition)async{
    return await db.collection('Competition').doc(id).update(updateCompetition);
   }


  //  Future editcontest(String id) async {
  //   return FirebaseFirestore.instance.collection("Competition").doc(id).update();
  // }

  Future<Stream<QuerySnapshot>> getCompetitionDetails() async {
    return FirebaseFirestore.instance.collection("Competition").snapshots();
  }

  List<UserModel> userList = [];
  Future<List<UserModel>> fetchAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("User").get();

    return userList = snapshot.docs.map((e) {
      return UserModel.fromJson(e.data());
    }).toList();
  }

// fetch request view
 Future<Stream<QuerySnapshot>> getRequestView() async {
  return FirebaseFirestore.instance.collection("Registerd Competition").snapshots();
}

  Future<Stream<QuerySnapshot>> getComplaintsDetails() async {
    return FirebaseFirestore.instance.collection("Complaints").snapshots();
  }

  UserModel? selecteduser;
  Future fetchSelectedUSerData(uid) async {
    final snapshot = await db.collection("User").doc(uid).get();
    if (snapshot.exists) {
      selecteduser = UserModel.fromJson(snapshot.data()!);
    }
  }

  Future updateComplaintStatus(newStatus, id) async {
    db.collection("Complaints").doc(id).update({"status": newStatus});
  }

  sendNotificationtouser(NotificationModel notificationModel) {
    final doc = db.collection("Notifications").doc();
    doc.set(notificationModel.toJson(doc.id));
  }

  Future<Stream<QuerySnapshot>> fetchNotification() async {
    return await FirebaseFirestore.instance
        .collection("Notifications")
        .where("toId", isEqualTo: adminuid)
        .snapshots();
  }

//------------------DELETE----------------
  Future deletePGPost(uid) async {
    final snapshot =
        await db.collection("Posts").where("uid", isEqualTo: uid).get();
    for (var i in snapshot.docs) {
      await _deleteDoc(i["postId"]);
    }
  }

  Future _deleteDoc(id) async {
    await db.collection("Posts").doc(id).delete();
  }

//==================
  Future deletePG(uid) async {
    db.collection("Photographers").doc(uid).delete();
  }

  Future deleteUser(uid) async {
    db.collection("User").doc(uid).delete();
  }

  //=====================
  List<AddCompetitionModel> competitonList = [];
  fetchAllCompetitionForSearch() async {
    final snapshot = await db.collection("Competition").get();
    competitonList = snapshot.docs.map((e) {
      return AddCompetitionModel.fromJson(e.data());
    }).toList();
  }

  List<AddCompetitionModel> searchResult = [];

  searchCompetition(
    String searchKey,
  ) {
    print(searchKey);
    searchResult = List.from(competitonList);
    searchResult = competitonList
        .where((element) =>
            element.title.toLowerCase().contains(searchKey.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
