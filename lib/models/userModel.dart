class userModel {
  final String title;
  final String username;
  final String email;
  final String bio;
  final String dp;
  final List<String> followers;
  final List<String> followings;
  userModel(
      {required this.title,
      required this.username,
      required this.email,
      required this.bio,
      required this.dp,
      required this.followers,
      required this.followings});
}
