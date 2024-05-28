class LikePostModel {
  String postId;
  String likedUid;
  String ?likeId;
  LikePostModel(
      {required this.likedUid,  this.likeId, required this.postId});
  Map<String, dynamic> toJson(id) =>
      {"postId": postId, "likedUid": likedUid, "likeId": id};
  factory LikePostModel.fromJson(Map<String, dynamic> json) {
    return LikePostModel(
        likedUid: json["likedUid"],
        likeId: json["likeId"],
        postId: json["postId"]);
  }
}
