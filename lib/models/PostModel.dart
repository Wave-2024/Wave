class PostModel {
  final String postType;
  final String video;
  final String caption;
  final DateTime dateOfPost;
  final String image;
  final String uid;
  final String post_id;
  final List<dynamic> likes;
  final List<dynamic> hiddenFrom;

  PostModel(
      {required this.caption,
      required this.postType,
      required this.video,
      required this.hiddenFrom,
      required this.dateOfPost,
      required this.image,
      required this.uid,
      required this.post_id,
      required this.likes});

  hideThisPostForMe(String myUid) {
    hiddenFrom.add(myUid);
  }
}
