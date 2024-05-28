import 'dart:developer';

import 'package:captura_lens/model/comment_model.dart';
import 'package:captura_lens/model/like_post_model.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:captura_lens/splash_screen.dart';
import 'package:captura_lens/user/user_categories.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserHomeDetails extends StatefulWidget {
  UserHomeDetails({super.key});

  @override
  State<UserHomeDetails> createState() => _UserHomeDetailsState();
}

class _UserHomeDetailsState extends State<UserHomeDetails>
    with TickerProviderStateMixin {
  // SearchController _searchController = SearchController();
  TextEditingController _searchController = TextEditingController();

  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchController = Provider.of<UserController>(context);

    print("hello");
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextFormField(
          //     onTap: () {
          //       searchController.fetchAllPost();
          //     },
          //     onChanged: (value) {

          //     },
          //     decoration: InputDecoration(
          //       suffixIcon: const Icon(
          //         Icons.search,
          //         color: CupertinoColors.black,
          //       ),
          //       filled: true,
          //       fillColor: Colors.white,
          //       hintText: "Search",
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(20.0),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .2,
            child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                      width: 20,
                    ),
                scrollDirection: Axis.horizontal,
                itemCount: photographyTypes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserCategories(
                            type: photographyTypes[index],
                             
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width * .6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey,
                          image: DecorationImage(
                              image: AssetImage(Imagecarosalslide[index]),
                              fit: BoxFit.fill)),
                      child: Text(
                        photographyTypes[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
          ),
          Consumer<UserController>(builder: (context, controller, child) {
            return Expanded(
              child: Column(
                children: [
                  FutureBuilder(
                      future: controller.fetchAllPost(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        }
                        if (snapshot.hasData && snapshot.data!.exists) {
                          Center(
                            child: Text(
                              'IS empty',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        final postList = controller.allPost;
                        postList.shuffle();
                        return Expanded(
                          child: ListView.builder(
                            itemCount: postList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: SizedBox(
                                  height: 600,
                                  child: Column(
                                    children: [
                                      FutureBuilder(
                                          future: controller
                                              .fetchSelectedPhotoGraphererData(
                                                  postList[index].uid),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox();
                                            }
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                snapshot.data!.profileUrl
                                                        .isEmpty
                                                    ? const CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        child: Icon(Icons
                                                            .supervised_user_circle_sharp),
                                                      )
                                                    : CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        backgroundImage:
                                                            NetworkImage(snapshot
                                                                .data!
                                                                .profileUrl),
                                                      ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data!.name,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            );
                                          }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    postList[index].imageUrl)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Consumer<UserController>(builder:
                                              (context, likeController, child) {
                                            return FutureBuilder(
                                                future: likeController
                                                    .fetchLikedpost(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid +
                                                        postList[index].postId),
                                                builder:
                                                    (context, likesnapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const SizedBox();
                                                  }
                                                  return IconButton(
                                                      onPressed: () async {
                                                        await likeController.likePost(
                                                            LikePostModel(
                                                                likedUid:
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid,
                                                                postId: postList[
                                                                        index]
                                                                    .postId),
                                                            FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid +
                                                                postList[index]
                                                                    .postId);
                                                      },
                                                      icon: Icon(
                                                        likeController
                                                                    .isLiked ==
                                                                true
                                                            ? CupertinoIcons
                                                                .heart_fill
                                                            : CupertinoIcons
                                                                .heart,
                                                        color: Colors.red,
                                                      ));
                                                });
                                          }),
                                          IconButton(
                                              onPressed: () {
                                                showBottomSheet(

                                                    // backgroundColor:
                                                    //     Colors.transparent,

                                                    // useSafeArea: true,
                                                    // isScrollControlled: true,
                                                    // enableDrag: true,
                                                    // enableDrag: true,
                                                    // backgroundColor:
                                                    //     const Color.fromARGB(
                                                    //         255, 70, 70, 70),
                                                    // showDragHandle: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        DraggableScrollableSheet(
                                                            snapSizes: const [
                                                              .3,
                                                              .5,
                                                              .7,
                                                            ],
                                                            snap: true,
                                                            expand: false,

                                                            // initialChildSize:
                                                            //     0.8,
                                                            // minChildSize: 0.7,
                                                            // maxChildSize: .9,
                                                            builder: (context,
                                                                scrollController) {
                                                              return Consumer<
                                                                  UserController>(
                                                                builder: (context,
                                                                    commentController,
                                                                    child) {
                                                                  return Container(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              20),
                                                                          topRight:
                                                                              Radius.circular(20)),
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          104,
                                                                          104,
                                                                          104),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              5,
                                                                          width:
                                                                              50,
                                                                          decoration: const BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                              color: Color.fromARGB(255, 48, 48, 48)),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        const Text(
                                                                          "Comments",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color.fromARGB(255, 152, 152, 152)),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                _commentController,
                                                                            decoration: InputDecoration(
                                                                                suffix: IconButton(
                                                                                    onPressed: () {
                                                                                      if (_commentController.text.isNotEmpty) {
                                                                                        commentController.addComment(postList[index].postId, CommentModel(comment: _commentController.text, time: time, date: date, commentedUid: FirebaseAuth.instance.currentUser!.uid)).then((value) {
                                                                                          _commentController.clear();
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    icon: const Icon(
                                                                                      CupertinoIcons.shift_fill,
                                                                                      color: Colors.white,
                                                                                    )),
                                                                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                                                                                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                                                                                hintText: "add a comment...",
                                                                                hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.grey),
                                                                                // fillColor: Colors.white,
                                                                                filled: false),
                                                                          ),
                                                                        ),
                                                                        FutureBuilder(
                                                                            future:
                                                                                commentController.fetchAllComment(postList[index].postId),
                                                                            builder: (context, snapshot) {
                                                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                return const SizedBox();
                                                                              }
                                                                              final commentList = commentController.comments;
                                                                              return Expanded(
                                                                                  child: commentList.isEmpty
                                                                                      ? const Center(
                                                                                          child: Text(
                                                                                            "No Comments",
                                                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey),
                                                                                          ),
                                                                                        )
                                                                                      : ListView.builder(
                                                                                          itemCount: commentList.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            return FutureBuilder(
                                                                                                future: commentController.fetchSelectedUserData(commentList[index].commentedUid),
                                                                                                builder: (context, snapshot) {
                                                                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                    return const SizedBox();
                                                                                                  }
                                                                                                  final userData = commentController.selectedUser;
                                                                                                  return ListTile(
                                                                                                    leading: userData!.profileUrl.isEmpty
                                                                                                        ? const Icon(
                                                                                                            CupertinoIcons.profile_circled,
                                                                                                            color: Colors.white,
                                                                                                            size: 30,
                                                                                                          )
                                                                                                        : CircleAvatar(
                                                                                                            backgroundImage: NetworkImage(userData.profileUrl),
                                                                                                          ),
                                                                                                    title: Text(
                                                                                                      userData.email,
                                                                                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                                                                                                    ),
                                                                                                    subtitle: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          commentList[index].comment,
                                                                                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          " ${commentList[index].time}",
                                                                                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  );
                                                                                                });
                                                                                          },
                                                                                        ));
                                                                            }),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }));
                                              },
                                              icon: const Icon(
                                                CupertinoIcons.chat_bubble,
                                                color: Colors.white,
                                              )),
                                          // const Spacer(),
                                          // IconButton(
                                          //     onPressed: () {},
                                          //     icon: const Icon(
                                          //       CupertinoIcons.bookmark,
                                          //       color: Colors.white,
                                          //     ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
