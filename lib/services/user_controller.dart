import 'dart:async';
 

import 'package:captura_lens/model/add_post.dart';
import 'package:captura_lens/model/booking_model.dart';
import 'package:captura_lens/model/comment_model.dart';
import 'package:captura_lens/model/complaint_model.dart';
import 'package:captura_lens/model/like_post_model.dart';
import 'package:captura_lens/model/notification_model.dart';
import 'package:captura_lens/model/photographer_model.dart';
import 'package:captura_lens/model/user_model.dart';
import 'package:captura_lens/user/user_home.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {
  // bool showDetails = false;

  // show() {
  //   showDetails = !showDetails;
  //   notifyListeners();
  // }

  int hours = 1;

  addHour() {
    hours++;

    notifyListeners();
  }

  lessHours() {
    if (hours != 1) {
      hours--;
      notifyListeners();
    }
  }

  final auth = FirebaseAuth.instance;

  Future userSignup(email, password, context, UserModel userModel) async {
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((credential) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("registration successful..!")));
      _registerUserData(userModel, credential.user!.uid).then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => UserHome()),
            (route) => false);
      });
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  Future signIn(email, password, context) async {
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((credential) {
      fetchCurrentUserData().then((value) => {
            if (value == true)
              {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => UserHome()),
                    (route) => false)
              }
            else
              {
                FirebaseAuth.instance.signOut().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Sorry,the user not exist")));
                }),
              }
          });
    });
  }

  //---------------------- D A T A B A S E
  final db = FirebaseFirestore.instance;
  Future _registerUserData(UserModel usermodel, id) async {
    db.collection("User").doc(id).set(usermodel.tojson(id));
  }

  UserModel? currentUserData;
  Future<bool> fetchCurrentUserData() async {
    final snapShot = await db
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapShot.exists) {
      currentUserData = UserModel.fromJson(snapShot.data()!);
      return true;
    } else {
      return false;
    }
  }

  UserModel? selectedUser;
  Future fetchSelectedUserData(uid) async {
    final snapShot = await db.collection("User").doc(uid).get();
    if (snapShot.exists) {
      selectedUser = UserModel.fromJson(snapShot.data()!);
    }
  }

  Future bookNewEventbyUSer(BookingModel bookingModel) async {
    final doc = db.collection("Booking Events").doc();
    doc.set(bookingModel.toJson(doc.id));
  }

  Future<String> registerComplaint(ComplaintModel complaintModel) async {
    final docs = db.collection("Complaints").doc();
    docs.set(complaintModel.toJson(docs.id));
    return docs.id;
  }

  List<AddPost> allPost = [];
  Future fetchAllPost() async {
    final snapshot = await db.collection("Posts").get();
    allPost = snapshot.docs.map((e) {
      return AddPost.fromJson(e.data());
    }).toList();
    // notifyListeners();
  }

  PhotographerModel? selectedpGData;
  Future<PhotographerModel?> fetchSelectedPhotoGraphererData(uid) async {
    if (uid != adminuid) {
      final snapshot = await db.collection("Photographers").doc(uid).get();
      if (snapshot.exists) {
        selectedpGData = PhotographerModel.fromJson(snapshot.data()!);

        return selectedpGData;
      }
      return null;
    }
  }

  List<AddPost> selectedPgPhotos = [];
  Future readselectedPhotoGrapherrPhotos(uid) async {
    final snapshot =
        await db.collection("Posts").where("uid", isEqualTo: uid).get();

    selectedPgPhotos = snapshot.docs.map((e) {
      return AddPost.fromJson(e.data());
    }).toList();
  }

  List<PhotographerModel> sortList = [];
  Future sortPhotographersByType(type) async {
    final snapshot = await db
        .collection("Photographers")
        .where("typePhotographer", isEqualTo: type)
        .get();

    sortList = snapshot.docs.map((e) {
      return PhotographerModel.fromJson(e.data());
    }).toList();
  }

  List<BookingModel> mybookingList = [];
  Future fetchCurrentuserBookingEvents() async {
    final snapshot = await db
        .collection("Booking Events")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    mybookingList = snapshot.docs.map((e) {
      return BookingModel.fromJson(e.data());
    }).toList();
  }

  sendNotificationtouser(NotificationModel notificationModel) {
    final doc = db.collection("Notifications").doc();
    doc.set(notificationModel.toJson(doc.id));
  }

  // List<NotificationModel> notifications = [];
  Future<Stream<QuerySnapshot>> fetchAllNotification() async {
    return FirebaseFirestore.instance
        .collection("Notifications")
        .where("toId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  //--------LIKE /COMMENT/ SAVE
  DocumentSnapshot<Map<String, dynamic>>? SNAPSHOT;
  Future likePost(LikePostModel likeModelPost, id) async {
    final SNAPSHOT = await db.collection("LikedPosts").doc(id).get();
    if (SNAPSHOT.exists) {
      await _disLikePost(id);
    } else {
      final docs = db
          .collection("LikedPosts")
          .doc(likeModelPost.likedUid + likeModelPost.postId);

      await docs.set(likeModelPost.toJson(docs.id));
    }
    notifyListeners();
    // fetchLikedpost(id);
    // notifyListeners();
    // notifyListeners();
  }

  _disLikePost(id) async {
    await db.collection("LikedPosts").doc(id).delete();
  }

  bool? isLiked;
  Future<bool> fetchLikedpost(id) async {
    // final streamShot = db.collection("LikedPosts").doc(id).snapshots();
    final SNAPSHOT = await db.collection("LikedPosts").doc(id).get();
    if (SNAPSHOT.exists) {
      isLiked = true;
      print(isLiked);
      return isLiked!;
    } else {
      isLiked = false;
      print(isLiked);
      return isLiked!;
    }
  }

  //-----------comment
  Future addComment(postId, CommentModel commentModel) async {
    final doc = db.collection("Posts").doc(postId).collection("comments").doc();
    await doc.set(commentModel.toJson(doc.id));
    notifyListeners();
  }

  List<CommentModel> comments = [];
  Future fetchAllComment(postId) async {
    final snapshot =
        await db.collection("Posts").doc(postId).collection("comments").get();
    comments = snapshot.docs.map((e) {
      return CommentModel.fromJson(e.data());
    }).toList();
  }

  //----serching
  List<BookingModel> searchBooking = [];

  serchBookingByEventName(String serchKey) {
    searchBooking = List.from(mybookingList);
    searchBooking = mybookingList
        .where((element) =>
            element.eventName.toLowerCase().contains(serchKey.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // List<AddPost> searchPost = [];
  // serchPostByUserName(String serchKey) {
  //   searchPost = List.from(allPost);
  //   searchPost=allPost.where((element) => element)
  // }
}
