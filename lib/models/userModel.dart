class NexusUser {
  final String uid;
  final String title;
  final String username;
  final String email;
  final String bio;
  final String dp;
  final String coverImage;
  final List<dynamic> followers;
  final List<dynamic> followings;
  final List<dynamic> posts;
  NexusUser(
      {required this.title,
        required this.posts,
      required this.coverImage,
      required this.uid,
      required this.username,
      required this.email,
      required this.bio,
      required this.dp,
      required this.followers,
      required this.followings});

      
}
