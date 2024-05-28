class ComplaintModel {
  String uid;
  String? complaintId;
  String complaint;
  String name;
  String phoneNumber;
  String status;

  ComplaintModel(
      {required this.complaint,
      this.complaintId,
      required this.name,
      required this.phoneNumber,
      required this.status,
      required this.uid});
  Map<String, dynamic> toJson(id) => {
        "complaint": complaint,
        "complaintId": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "uid": uid,
        "status": status,
      };

  factory ComplaintModel.fromjson(Map<String, dynamic> json) {
    return ComplaintModel(
        status: json["status"],
        complaint: json["complaint"],
        complaintId: json["complaintId"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        uid: json["uid"]);
  }
}
