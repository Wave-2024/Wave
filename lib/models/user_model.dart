// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:wave/utils/enums.dart';

class User {
  bool verified;
  String name;
  String email;
  List<dynamic> following;
  List<dynamic> followers;
  List<dynamic> posts;
  String? displayPicture;
  String? bio;
  String? url;
  String id;
  String username;
  List<dynamic> stories;
  List<dynamic>? blocked;
  String coverPicture;
  List<dynamic>? savedPosts;
  List<dynamic>? messages;
  ACCOUNT_TYPE account_type;

  User({
    required this.verified,
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
    required this.account_type,
  });

  User copyWith({
    bool? verified,
    String? name,
    String? email,
    List<dynamic>? following,
    List<dynamic>? followers,
    List<dynamic>? posts,
    String? displayPicture,
    String? bio,
    String? url,
    String? id,
    String? username,
    List<dynamic>? stories,
    List<dynamic>? blocked,
    String? coverPicture,
    List<dynamic>? savedPosts,
    List<dynamic>? messages,
    ACCOUNT_TYPE? account_type,
  }) {
    return User(
      verified: verified ?? this.verified,
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
      account_type: account_type ?? this.account_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verified': verified,
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
      'account_type': account_type.toString().split('.').last,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        verified: map['verified'] as bool,
        name: map['name'] as String,
        email: map['email'] as String,
        following: List<dynamic>.from((map['following'] as List<dynamic>)),
        followers: List<dynamic>.from((map['followers'] as List<dynamic>)),
        posts: List<dynamic>.from((map['posts'] as List<dynamic>)),
        displayPicture: map['displayPicture'] != null
            ? map['displayPicture'] as String
            : null,
        bio: map['bio'] != null ? map['bio'] as String : null,
        url: map['url'] != null ? map['url'] as String : null,
        id: map['id'] as String,
        username: map['username'] as String,
        stories: List<dynamic>.from((map['stories'] as List<dynamic>)),
        blocked: map['blocked'] != null
            ? List<dynamic>.from((map['blocked'] as List<dynamic>))
            : null,
        coverPicture: map['coverPicture'] as String,
        savedPosts: map['savedPosts'] != null
            ? List<dynamic>.from((map['savedPosts'] as List<dynamic>))
            : null,
        messages: map['messages'] != null
            ? List<dynamic>.from((map['messages'] as List<dynamic>))
            : null,
        account_type: map['account_type'] != null
            ? (map['account_type'] == 'PRIVATE')
                ? ACCOUNT_TYPE.PRIVATE
                : ACCOUNT_TYPE.PUBLIC
            : ACCOUNT_TYPE.PUBLIC);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(verified: $verified, name: $name, email: $email, following: $following, followers: $followers, posts: $posts, displayPicture: $displayPicture, bio: $bio, url: $url, id: $id, username: $username, stories: $stories, blocked: $blocked, coverPicture: $coverPicture, savedPosts: $savedPosts, messages: $messages, account_type: $account_type)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.verified == verified &&
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
        listEquals(other.messages, messages) &&
        other.account_type == account_type;
  }

  @override
  int get hashCode {
    return verified.hashCode ^
        name.hashCode ^
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
        messages.hashCode ^
        account_type.hashCode;
  }
}
