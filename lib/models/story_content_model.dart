// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:wave/utils/enums.dart';

class StoryContent {
  String id;
  DateTime createdAt;
  STORY_TYPE story_type;
  List<dynamic> seenBy;
  StoryContent({
    required this.id,
    required this.createdAt,
    required this.story_type,
    required this.seenBy,
  });

  StoryContent copyWith({
    String? id,
    DateTime? createdAt,
    STORY_TYPE? story_type,
    List<dynamic>? seenBy,
  }) {
    return StoryContent(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      story_type: story_type ?? this.story_type,
      seenBy: seenBy ?? this.seenBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'story_type': story_type.toString().split('.').last,
      'seenBy': seenBy,
    };
  }

  static STORY_TYPE decideStoryType(String type) {
    if (type == 'POST') {
      return STORY_TYPE.POST;
    } else if (type == 'IMAGE') {
      return STORY_TYPE.IMAGE;
    } else if (type == 'VIDEO') {
      return STORY_TYPE.VIDEO;
    } else {
      return STORY_TYPE.TEXT;
    }
  }

  factory StoryContent.fromMap(Map<String, dynamic> map) {
    return StoryContent(
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      story_type: decideStoryType(map['story_type']),
      seenBy: List<dynamic>.from((map['seenBy'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryContent.fromJson(String source) =>
      StoryContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoryContent(id: $id, createdAt: $createdAt, story_type: $story_type, seenBy: $seenBy)';
  }

  @override
  bool operator ==(covariant StoryContent other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.story_type == story_type &&
        listEquals(other.seenBy, seenBy);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        story_type.hashCode ^
        seenBy.hashCode;
  }
}
