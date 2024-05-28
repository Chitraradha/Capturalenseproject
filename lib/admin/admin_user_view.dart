import 'package:captura_lens/services/admin_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminUserView extends StatefulWidget {
  const AdminUserView({super.key});

  @override
  State<AdminUserView> createState() => _AdminUserViewState();
}

class _AdminUserViewState extends State<AdminUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "View Users",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: AdminController().fetchAllUsers().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }

                  
                  final data = snapshot.data;
                  return Expanded(
                      child: data!.isEmpty
                          ? Center(
                              child: Text(
                                "No User",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 20,
                                  ),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    children: [
                                       SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                         
                                          data[index].profileUrl.isEmpty
                                              ? CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  radius: 50,
                                                  child: Icon(Icons
                                                      .supervised_user_circle_sharp))
                                              : CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                      data[index].profileUrl),
                                                ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data[index].name,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                data[index].email,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                data[index]
                                                    .phoneNumber
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                data[index].place,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // ElevatedButton(
                                          //   onPressed: () {},
                                          //   style: ElevatedButton.styleFrom(
                                          //       padding: const EdgeInsets.symmetric(
                                          //           vertical: 12, horizontal: 40),
                                          //       shape: RoundedRectangleBorder(
                                          //           borderRadius:
                                          //               BorderRadius.circular(10)),
                                          //       foregroundColor: Colors.black,
                                          //       backgroundColor: Colors.white),
                                          //   child: const Text(
                                          //     "Accepted",
                                          //     style: TextStyle(color: Colors.black),
                                          //   ),
                                          // ),
                                          ElevatedButton(
                                            onPressed: () {
                                              AdminController()
                                                  .deleteUser(data[index].id)
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 40),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                foregroundColor: Colors.black,
                                                backgroundColor: Colors.white),
                                            child: const Text(
                                              "Remove",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }));
                }),
          ],
        ),
      ),
    );
  }
}
