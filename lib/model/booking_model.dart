class BookingModel {
  String? bookingId;
  String uid;
  String photographerId;
  String name;
  String address;
  String eventName;
  String from;
  String to;
  // int hours;
  String status;
  String photographyType;
  String number;

  BookingModel(
      {required this.address,
      this.bookingId,
      required this.status,
      required this.eventName,
      required this.from,
      // required this.hours,
      required this.name,
      required this.photographerId,
      required this.photographyType,
      required this.to,
      required this.uid,
      required this.number
      });
  Map<String, dynamic> toJson(id) => {
        "address": address,
        "bookingId": id,
        "eventName": eventName,
        "from": from,
        "to": to,
        // "hours": hours,
        "name": name,
        "photographerId": photographerId,
        "photographyType": photographyType,
        "uid": uid,
        "status":status,
        "number":number,
      };

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
        address: json["address"],
        status: json["status"],
        bookingId: json["bookingId"],
        eventName: json["eventName"],
        from: json["from"],
        // hours: json["hours"],
        name: json["name"],
        photographerId: json["photographerId"],
        photographyType: json["photographyType"],
        to: json["to"],
        uid: json["uid"],
        number:json['number']
        
        );
        
  }
}
