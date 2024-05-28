class AddCompetitionModel {
  String imageURL;
  String title;
  String deadline;
  String prizeAndDescription;
  String place;
  String eventId;
  String eventUploadedDate;
  bool payment;
  String upiId;
  double registrationfee;

  AddCompetitionModel(
      {required this.deadline,
      required this.upiId,
      required this.registrationfee,
      required this.payment,
      required this.eventId,
      required this.eventUploadedDate,
      required this.imageURL,
      required this.place,
      required this.prizeAndDescription,
      required this.title});
  Map<String, dynamic> toJson() => {
        "imageURL": imageURL,
        "upiId":upiId,
        "registrationfee": registrationfee,
        "payment": payment,
        "title": title,
        "deadline": deadline,
        "prizeAndDescription": prizeAndDescription,
        "place": place,
        "id": eventId,
        "eventUploadedDate": eventUploadedDate
      };

  factory AddCompetitionModel.fromJson(Map<String, dynamic> json) {
    return AddCompetitionModel(
        deadline: json["deadline"],
        upiId:json["upiId"],
        registrationfee: json["registrationfee"],
        payment: json["payment"],
        eventId: json["id"],
        eventUploadedDate: json["eventUploadedDate"],
        imageURL: json["imageURL"],
        place: json["place"],
        prizeAndDescription: json["prizeAndDescription"],
        title: json["title"]);
  }
}
