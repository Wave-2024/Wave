// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:wave/models/post_content_model.dart';

class Post {
  // Doc based variables
  String id;
  List<PostContent> postList;
  DateTime createdAt;
  String userId;
  String caption;
  List<dynamic> mentions;
  Post({
    required this.id,
    required this.postList,
    required this.createdAt,
    required this.userId,
    required this.caption,
    required this.mentions,
  });
  // Collection based variables
  /*
    likes
    comments
    reports
  */

  Post copyWith({
    String? id,
    List<PostContent>? postList,
    DateTime? createdAt,
    String? userId,
    String? caption,
    List<dynamic>? mentions,
  }) {
    
    return Post(
      id: id ?? this.id,
      postList: postList ?? this.postList,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      caption: caption ?? this.caption,
      mentions: mentions ?? this.mentions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postList': postList.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
      'caption': caption,
      'mentions': mentions,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      postList: List<PostContent>.from(
        (map['postList'] as List<dynamic>).map<PostContent>(
          (x) => PostContent.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      userId: map['userId'] as String,
      caption: map['caption'] as String,
      mentions: List<dynamic>.from((map['mentions'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, postList: $postList, createdAt: $createdAt, userId: $userId, caption: $caption, mentions: $mentions)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.postList, postList) &&
        other.createdAt == createdAt &&
        other.userId == userId &&
        other.caption == caption &&
        listEquals(other.mentions, mentions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postList.hashCode ^
        createdAt.hashCode ^
        userId.hashCode ^
        caption.hashCode ^
        mentions.hashCode;
  }
}
