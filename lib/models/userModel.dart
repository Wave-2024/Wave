// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

NexusUser userFromJson(String str) => NexusUser.fromJson(json.decode(str));

String userToJson(NexusUser data) => json.encode(data.toJson());

class NexusUser {
  NexusUser({
    required this.bio,
    required this.coverImage,
    required this.dp,
    required this.email,
    required this.followers,
    required this.followings,
    required this.title,
    required this.uid,
    required this.username,
    required this.story,
    required this.storyTime,
    required this.views,
  });

  String bio;
  String coverImage;
  String dp;
  String email;
  List<dynamic> followers;
  List<dynamic> followings;
  String title;
  String uid;
  String username;
  String story;
  DateTime storyTime;
  List<dynamic> views;

  factory NexusUser.fromJson(Map<String, dynamic> json) => NexusUser(
        bio: json["bio"],
        coverImage: json["coverImage"],
        dp: json["dp"],
        views: json['views'] ?? [],
        email: json["email"],
        followers: List<String>.from(json["followers"].map((x) => x)),
        followings: List<String>.from(json["followings"].map((x) => x)),
        title: json["title"],
        uid: json["uid"],
        username: json["username"],
        story: json['story'],
        storyTime: DateTime.parse(json['storyTime']),
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "coverImage": coverImage,
        "dp": dp,
        "email": email,
        "followers": List<dynamic>.from(followers.map((x) => x)),
        "followings": List<dynamic>.from(followings.map((x) => x)),
        "title": title,
        "uid": uid,
        "username": username,
        'views': [],
      };

  addStory(String storyImage) {
    story = storyImage;
    storyTime = DateTime.now();
    views = [];
  }

  changeDP(String newDp){
    dp = newDp;
  }

  removeStroy() {
    story = '';
    views = [];
  }

  addFollowing(String newUid){
    followings.add(newUid);
  }

  addFolllower(String newUid){
    followers.add(newUid);
  }

  removeFollowing(String existingUser){
    followings.remove(existingUser);
  }

  removeFollower(String existingUser){
    followers.remove(existingUser);
  }

  editProfile(String newUsername,String newTitle,String newBio){
    username = newUsername;
    title = newTitle;
    bio = newBio;
  }

}
