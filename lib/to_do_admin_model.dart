// class AdminModel{
//   String title;
//   String deadline;
//   String price;
//   String place;
//   String? id;


//   AdminModel({required this.title,required this.deadline,required this.price,required this.place,this.id});

//   Map<String,dynamic>tojson(id)=>{
//     "Title":title,
//     "Deadline":deadline,
//     "Prize and Description":price,
//     "Place":place,
//     "id":id
//   };

//   factory AdminModel.fromjson(Map<String,dynamic>json){
//     return AdminModel(title: json["Title"], deadline: json["Deadline"], price: json["Prize and Description"], place: json["Place"],id: json["id"]);
//   }
// }