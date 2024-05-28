import 'package:captura_lens/services/admin_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminNotification extends StatefulWidget {
  const AdminNotification({super.key});

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  Stream? stream;
  fetchStream() async {
    stream = await AdminController().fetchNotification();
    setState(() {});
  }

  @override
  void initState() {
    fetchStream();

    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Notification',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? snapshot.data.docs.isEmpty
                    ? const Center(
                        child: Text(
                        "No Notification",
                        style: TextStyle(color: Colors.white),
                      ))
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data.docs[index];
                          return Consumer<AdminController>(
                              builder: (context, controller, child) {
                            return FutureBuilder(
                                future: controller
                                    .fetchSelectedUSerData(data["fromId"]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox();
                                  }
                                  
                                  final uData = controller.selecteduser;
                                  // return ListTile(
                                  // // leading: uData != null && uData!.name.isNotEmpty ? Text(uData!.name.toString()) : Text(''),

                                  //   // leading:Text(uData!.phoneNumber.toString()),
                                  //   //  uData!.profileUrl.isEmpty
                                  //   //     ? const CircleAvatar(
                                  //   //         backgroundColor: Colors.grey,
                                  //   //         child: Icon(
                                  //   //           Icons.person,
                                  //   //           color: Colors.white,
                                  //   //         ),
                                  //   //       )
                                  //   //     : CircleAvatar(
                                  //   //         backgroundColor: Colors.grey,
                                  //   //         backgroundImage:
                                  //   //             NetworkImage(uData.profileUrl),
                                  //   //       ),
                                  //   title: Row(
                                  //     children: [
                                  //       Text(
                                  //         data["type"],
                                  //         style:
                                  //             const TextStyle(color: Colors.white),
                                  //       ),
                                       
                                        
                                  //        Text(
                                  //         data["message"],
                                  //         style:
                                  //             const TextStyle(color: Colors.white),
                                  //       ),
                                  //     ],
                                  //   ),

                                  // );
                                  

                                    return ListTile(
                                      title: Text(data["type"],style: TextStyle(color: Colors.white),),
                                      subtitle: Text(data["message"],style: TextStyle(color: Colors.white),),
                                    );

                                });
                          });
                        })
                : const Center(
                    child: Text("Loading...",
                        style: TextStyle(color: Colors.white)),
                  );
          }),
    );
  }
}
