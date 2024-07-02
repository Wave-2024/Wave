// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:wave/models/story_content_model.dart';

class Story {
  String userId;
  String id;
  List<StoryContent> contents;
  Story({
    required this.userId,
    required this.id,
    required this.contents,
  });

  Story copyWith({
    String? userId,
    String? id,
    List<StoryContent>? contents,
  }) {
    return Story(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      contents: contents ?? this.contents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'contents': contents.map((x) => x.toMap()).toList(),
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      userId: map['userId'] as String,
      id: map['id'] as String,
      contents: List<StoryContent>.from(
        (map['contents'] as List<dynamic>).map<StoryContent>(
          (x) => StoryContent.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) =>
      Story.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Story(userId: $userId, id: $id, contents: $contents)';

  @override
  bool operator ==(covariant Story other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.id == id &&
        listEquals(other.contents, contents);
  }

  @override
  int get hashCode => userId.hashCode ^ id.hashCode ^ contents.hashCode;
}
