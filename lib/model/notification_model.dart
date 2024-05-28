 
class NotificationModel {
  String toId;
  String fromId;
  String? notificationId;
  String message;
  String date;
  String time;
  String type;
  NotificationModel(
      {required this.date,
      required this.fromId,
      required this.type,
      required this.message,
      this.notificationId,
      required this.time,
      required this.toId});
  Map<String, dynamic> toJson(id) => {
        "date": date,
        "type": type,
        "message": message,
        "notificationId": id,
        "time": time,
        "toId": toId,
        "fromId": fromId
      };
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        type: json["type"],
        date: json["date"],
        fromId: json["fromId"],
        message: json["message"],
        notificationId: json["notificationId"],
        time: json["time"],
        toId: json["toId"]);
  }
}
