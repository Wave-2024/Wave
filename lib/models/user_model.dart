// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  String name;
  String email;
  List<String> following;
  List<String> followers;
  List<String> posts;
  String? displayPicture;
  String? bio;
  String? url;
  String id;
  String username;
  List<String> stories;
  List<String>? blocked;
  String coverPicture;
  List<String>? savedPosts;
  List<String>? messages;
  
  User({
    required this.name,
    required this.email,
    required this.following,
    required this.followers,
    required this.posts,
    this.displayPicture,
    this.bio,
    this.url,
    required this.id,
    required this.username,
    required this.stories,
    required this.blocked,
    required this.coverPicture,
    this.savedPosts,
    this.messages,
  });

  User copyWith({
    String? name,
    String? email,
    List<String>? following,
    List<String>? followers,
    List<String>? posts,
    String? displayPicture,
    String? bio,
    String? url,
    String? id,
    String? username,
    List<String>? stories,
    List<String>? blocked,
    String? coverPicture,
    List<String>? savedPosts,
    List<String>? messages,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      posts: posts ?? this.posts,
      displayPicture: displayPicture ?? this.displayPicture,
      bio: bio ?? this.bio,
      url: url ?? this.url,
      id: id ?? this.id,
      username: username ?? this.username,
      stories: stories ?? this.stories,
      blocked: blocked ?? this.blocked,
      coverPicture: coverPicture ?? this.coverPicture,
      savedPosts: savedPosts ?? this.savedPosts,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'following': following,
      'followers': followers,
      'posts': posts,
      'displayPicture': displayPicture,
      'bio': bio,
      'url': url,
      'id': id,
      'username': username,
      'stories': stories,
      'blocked': blocked,
      'coverPicture': coverPicture,
      'savedPosts': savedPosts,
      'messages': messages,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      following: List<String>.from((map['following'] as List<dynamic>)),
      followers: List<String>.from((map['followers'] as List<dynamic>)),
      posts: List<String>.from((map['posts'] as List<dynamic>)),
      displayPicture: map['displayPicture'] != null ? map['displayPicture'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      id: map['id'] as String,
      username: map['username'] as String,
      stories: List<String>.from((map['stories'] as List<dynamic>)),
      blocked: map['blocked'] != null ? List<String>.from((map['blocked'] as List<dynamic>)) : null,
      coverPicture: map['coverPicture'] as String,
      savedPosts: map['savedPosts'] != null ? List<String>.from((map['savedPosts'] as List<dynamic>)) : null,
      messages: map['messages'] != null ? List<String>.from((map['messages'] as List<dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, following: $following, followers: $followers, posts: $posts, displayPicture: $displayPicture, bio: $bio, url: $url, id: $id, username: $username, stories: $stories, blocked: $blocked, coverPicture: $coverPicture, savedPosts: $savedPosts, messages: $messages)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.email == email &&
      listEquals(other.following, following) &&
      listEquals(other.followers, followers) &&
      listEquals(other.posts, posts) &&
      other.displayPicture == displayPicture &&
      other.bio == bio &&
      other.url == url &&
      other.id == id &&
      other.username == username &&
      listEquals(other.stories, stories) &&
      listEquals(other.blocked, blocked) &&
      other.coverPicture == coverPicture &&
      listEquals(other.savedPosts, savedPosts) &&
      listEquals(other.messages, messages);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      following.hashCode ^
      followers.hashCode ^
      posts.hashCode ^
      displayPicture.hashCode ^
      bio.hashCode ^
      url.hashCode ^
      id.hashCode ^
      username.hashCode ^
      stories.hashCode ^
      blocked.hashCode ^
      coverPicture.hashCode ^
      savedPosts.hashCode ^
      messages.hashCode;
  }
}
