class CommentModel {
  String commentedUid;
  String comment;
  String ?commentId;
  String date;
  String time;

  CommentModel(
      {required this.comment,
      required this.time,
      required this.date,
       this.commentId,
      required this.commentedUid});

  Map<String, dynamic> toJson(id) => {
        "commentedUid": commentedUid,
        "comment": comment,
        "time": time,
        "date": date,
        "commentId": id
      };
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        date: json["date"],
        time: json["time"],
        comment: json["comment"],
        commentId: json["commentId"],
        commentedUid: json["commentedUid"]);
  }
}
