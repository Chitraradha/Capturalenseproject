// import 'package:captura_lens/to_do_admin_home.dart';
// import 'package:captura_lens/to_do_admin_model.dart';
// import 'package:flutter/material.dart';

// class Homeone extends StatefulWidget {
//   const Homeone({super.key});

//   @override
//   State<Homeone> createState() => _HomeoneState();
// }

// class _HomeoneState extends State<Homeone> {
//   List<AdminModel>? list; // Original list of events
//   List<AdminModel>? filteredList; // Filtered list of events
//   AdminModel? adminModel;
//   AdminController obj3 = AdminController();
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchData();

//     // Add a listener to the search controller to filter the list based on the query
//     searchController.addListener(() {
//       setState(() {
//         filterList();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchData() async {
//     list = await obj3.fetchAllEvents();
//     setState(() {
//       filteredList = list; // Initially, filteredList contains all events
//     });
//   }

//   void filterList() {
//     final query = searchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         filteredList = list; // If query is empty, show all events
//       } else {
//         filteredList = list?.where((event) {
//           return event.title.toLowerCase().contains(query) ||
//               event.deadline.toLowerCase().contains(query) ||
//               event.price.toLowerCase().contains(query);
//         }).toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(100.0),
//           child: Container(
//             height: 100.0,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(20.0),
//               ),
//             ),
//             child: AppBar(
//               toolbarHeight: 100,
//               automaticallyImplyLeading: false,
//               backgroundColor: Colors.black,
//               title: TextFormField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   suffixIcon: Icon(Icons.search),
//                   filled: true,
//                   fillColor: Colors.white,
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   hintText: "Search",
//                   hintStyle: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         body: filteredList == null
//             ? Center(child: CircularProgressIndicator())
//             : Container(
//           height: MediaQuery.of(context).size.height,
//           child: Expanded(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredList?.length ?? 0,
//                     itemBuilder: (context, index) {
//                       final event = filteredList![index];
//                       return GestureDetector(
//                         onTap: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) => const PhotoEventDetails()));
//                         },
//                         child: Container(
//                           height: 200,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                   color: Colors.grey)),
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Container(
//                                       color: Colors.grey,
//                                       width: 50,
//                                       height: 70,
//                                       child: Center(
//                                           child: Text("Photo")),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   width: 30,
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment
//                                         .start,
//                                     children: [
//                                       Text(
//                                         event.title,
//                                         style: TextStyle(
//                                             fontWeight:
//                                             FontWeight
//                                                 .bold),
//                                       ),
//                                       SizedBox(
//                                         height: 8,
//                                       ),
//                                       Text(
//                                         event.deadline,
//                                         style: TextStyle(
//                                             fontWeight:
//                                             FontWeight
//                                                 .bold),
//                                       ),
//                                       SizedBox(
//                                         height: 8,
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           event.price,
//                                           style: TextStyle(
//                                               fontWeight:
//                                               FontWeight
//                                                   .bold),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 8,
//                                       ),
//                                       Text(
//                                         event.place,
//                                         style: TextStyle(
//                                             fontWeight:
//                                             FontWeight
//                                                 .bold),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//     );
//   }
// }