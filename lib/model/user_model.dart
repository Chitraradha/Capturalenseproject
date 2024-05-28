class UserModel {
  String email;
  String password;
  String place;
  int phoneNumber;
  String? id;
  String profileUrl;
  String name;

  UserModel(
      {
      required this.profileUrl,
      required this.email,
       this.id,
      required this.password,
      required this.phoneNumber,
      required this.place,
      required this.name
      });

  Map<String, dynamic> tojson(uid) => {
        "email": email,
        "password": password,
        "place": place,
        "phoneNumber": phoneNumber,
        "id": uid,
        "profileUrl": profileUrl,
        "name":name
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        profileUrl: json["profileUrl"],
        email: json["email"],
        id: json["id"],
        password: json["password"],
        phoneNumber: json["phoneNumber"],
        place: json["place"],
        name: json["name"],
      );
  }
}
