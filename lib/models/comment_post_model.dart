// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comment {
  String id;
  String userId;
  String comment;
  DateTime createdAt;
  String postId;
  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.comment,
    required this.createdAt,
  });

  Comment copyWith({
    String? id,
    String? userId,
    String? comment,
    DateTime? createdAt,
    String? postId,
  }) {
    return Comment(
      postId: postId??this.postId,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'postId':postId,
      'comment': comment,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      comment: map['comment'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, userId: $userId, comment: $comment, createdAt: $createdAt, postId: $postId)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
          other.postId==postId &&
      other.userId == userId &&
      other.comment == comment &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      comment.hashCode ^
      createdAt.hashCode;
  }
}
