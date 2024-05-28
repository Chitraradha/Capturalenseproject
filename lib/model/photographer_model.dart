class PhotographerModel {
  String email;
  String password;
  String place;
  String typePhotographer;
  int adherNumber;
  int phoneNumber;
  String id;
  String profileUrl;
  String name;

  PhotographerModel(
      {required this.adherNumber,
      required this.profileUrl,
      required this.email,
      required this.id,
      required this.password,
      required this.phoneNumber,
      required this.place,
      required this.typePhotographer,required this.name});

  Map<String, dynamic> tojson() => {
        "email": email,
        "password": password,
        "place": place,
        "typePhotographer": typePhotographer,
        "adherNumber": adherNumber,
        "phoneNumber": phoneNumber,
        "id": id,
        "profileUrl": profileUrl,
        "name":name
      };

  factory PhotographerModel.fromJson(Map<String, dynamic> json) {
    return PhotographerModel(
        adherNumber: json["adherNumber"],
        profileUrl: json["profileUrl"],
        email: json["email"],
        id: json["id"],
        password: json["password"],
        phoneNumber: json["phoneNumber"],
        place: json["place"],
        name: json['name'],
        typePhotographer: json["typePhotographer"]);


  }
}
