
class AddPost {
  String imageUrl;
  String uid;
  String postId;

  AddPost({required this.imageUrl, required this.postId, required this.uid});

  Map<String, dynamic> toJson() =>
      {"imageUrl": imageUrl, "uid": uid, "postId": postId};

  factory AddPost.fromJson(Map<String, dynamic> json) {
    return AddPost(
        imageUrl: json["imageUrl"], postId: json["postId"], uid: json["uid"]);
  }
}
