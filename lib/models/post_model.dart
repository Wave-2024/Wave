// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:wave/models/post_content_model.dart';

class Post {
  // Doc based variables
  String id;
  List<PostContent> postList;
  DateTime createdAt;
  String userId;
  List<dynamic> likes;
  List<dynamic> mentions;
  Post({
    required this.id,
    required this.postList,
    required this.createdAt,
    required this.userId,
    required this.likes,
    required this.mentions,
  });
  // Collection based variables
  /*
    comments
    reports
  */
  

  Post copyWith({
    String? id,
    List<PostContent>? postList,
    DateTime? createdAt,
    String? userId,
    List<dynamic>? likes,
    List<dynamic>? mentions,
  }) {
    return Post(
      id: id ?? this.id,
      postList: postList ?? this.postList,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      likes: likes ?? this.likes,
      mentions: mentions ?? this.mentions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postList': postList.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
      'likes': likes,
      'mentions': mentions,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      postList: List<PostContent>.from((map['postList'] as List<int>).map<PostContent>((x) => PostContent.fromMap(x as Map<String,dynamic>),),),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      userId: map['userId'] as String,
      likes: List<dynamic>.from((map['likes'] as List<dynamic>)),
      mentions: List<dynamic>.from((map['mentions'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, postList: $postList, createdAt: $createdAt, userId: $userId, likes: $likes, mentions: $mentions)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      listEquals(other.postList, postList) &&
      other.createdAt == createdAt &&
      other.userId == userId &&
      listEquals(other.likes, likes) &&
      listEquals(other.mentions, mentions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      postList.hashCode ^
      createdAt.hashCode ^
      userId.hashCode ^
      likes.hashCode ^
      mentions.hashCode;
  }
}
