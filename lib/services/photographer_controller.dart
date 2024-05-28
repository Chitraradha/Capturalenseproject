import 'package:captura_lens/model/add_competition_model.dart';
import 'package:captura_lens/model/add_post.dart';
import 'package:captura_lens/model/notification_model.dart';
import 'package:captura_lens/model/photographer_model.dart';
import 'package:captura_lens/model/register_competition_model.dart';
import 'package:captura_lens/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class PhotographerController with ChangeNotifier {
  final db = FirebaseFirestore.instance;
//------------------ r e a d
  PhotographerModel? currentUserData;
  Future readPhotographerData() async {
    final snapshot = await db
        .collection("Photographers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      currentUserData = PhotographerModel.fromJson(snapshot.data()!);
    }
  }

  List<AddPost> currentUserPosts = [];
  Future readCurrentPhotoGrapherrPhotoa() async {
    final snapshot = await db
        .collection("Posts")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    currentUserPosts = snapshot.docs.map((e) {
      return AddPost.fromJson(e.data());
    }).toList();
  }

  Future<Stream<QuerySnapshot>> getCompetitionDetails() async {
    return FirebaseFirestore.instance.collection("Competition").snapshots();
  }


    Future updateprofile(id,Map<String,dynamic> updateprofile)async{
    return await db.collection('Photographers').doc(id).update(updateprofile);
   }


  Future<Stream<QuerySnapshot>> getBookingDetails() async {
    return FirebaseFirestore.instance
        .collection("Booking Events")
        .where("photographerId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> fetchAllNotification() async {
    return FirebaseFirestore.instance
        .collection("Notifications")
        .where("toId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

//---------------------------------u p d a t e

//------------d e l e t e
  deletePostByPG(iid) async {
    await db.collection("Posts").doc(iid).delete();
    notifyListeners();
  }

//---------------------------------c r e a t e
  Future addPhotoDetails(PhotographerModel newPhotographer, String id) async {
    return await FirebaseFirestore.instance
        .collection("Photographers")
        .doc(id)
        .set(newPhotographer.tojson());
  }

  Future photoPost(AddPost addPost, String id) async {
    return await FirebaseFirestore.instance
        .collection("Posts")
        .doc(id)
        .set(addPost.toJson());
  }

  UserModel? selecteduser;
  Future fetchSelectedUSerData(uid) async {
    final snapshot = await db.collection("User").doc(uid).get();
    if (snapshot.exists) {
      selecteduser = UserModel.fromJson(snapshot.data()!);
    }
  }

  Future updateEventStatus(newStatus, docId) async {
    await db
        .collection("Booking Events")
        .doc(docId)
        .update({"status": newStatus});
  }

  sendNotificationtouser(NotificationModel notificationModel) {
    final doc = db.collection("Notifications").doc();
    doc.set(notificationModel.toJson(doc.id));
  }

  Future registerCompetition(
      id, RegisterCompetitionModel registerCompetitionModel) async {
    db.collection("Registerd Competition").doc(id).set(registerCompetitionModel.toJson(id));
  }

  //         searching
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
