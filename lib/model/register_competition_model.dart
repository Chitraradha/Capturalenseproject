class RegisterCompetitionModel {
  String? regId;
  String competitionId;
  String uid;
  String contactNumber;
  String name;
  String email;
  bool payment;

  RegisterCompetitionModel(
      {required this.competitionId,
      required this.contactNumber,
      required this.name,
      required this.email,
      required this.payment,
      this.regId,
      required this.uid});
  Map<String, dynamic> toJson(id) => {
        "regId": id,
        "competitionId": competitionId,
        "uid": uid,
        "name": name,
        "email":email,
        "contactNumber": contactNumber,
        "payment": payment
      };
  factory RegisterCompetitionModel.fromjson(Map<String, dynamic> json) {
    return RegisterCompetitionModel(
        contactNumber: json["contactNumber"],
        competitionId: json["competitionId"],
        name: json["name"],
        email:json["email"],
        payment: json["payment"],
        regId: json["regId"],
        uid: json["uid"]);
  }
}
