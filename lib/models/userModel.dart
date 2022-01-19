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

  factory NexusUser.fromJson(Map<String, dynamic> json) => NexusUser(
    bio: json["bio"],
    coverImage: json["coverImage"],
    dp: json["dp"],
    email: json["email"],
    followers: List<String>.from(json["followers"].map((x) => x)),
    followings: List<String>.from(json["followings"].map((x) => x)),
    title: json["title"],
    uid: json["uid"],
    username: json["username"],
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
  };
}
