class PostModel {
  final String caption;
  final String dateOfPost;
  final String image;
  final String uid;
  final String post_id;
  final List<dynamic> likes;

  PostModel(
      {required this.caption,
      required this.dateOfPost,
      required this.image,
      required this.uid,
      required this.post_id,
      required this.likes});

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'image': image,
      'uid': uid,
      'post_uid': post_id,
      'likes': likes,
    };
  }
}
