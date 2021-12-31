class userModel {
  final String uid;
  final String title;
  final String username;
  final String email;
  final String bio;
  final String dp;
  final String coverImage;
  final List<String> followers;
  final List<String> followings;
  userModel(
      {required this.title,
      required this.coverImage,
      required this.uid,
      required this.username,
      required this.email,
      required this.bio,
      required this.dp,
      required this.followers,
      required this.followings});
}
