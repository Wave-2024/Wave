// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReplyComment {
  String reply;
  String id;
  String userId;
  String parentCommentId;
  DateTime createdAt;
  
  ReplyComment({
    required this.reply,
    required this.id,
    required this.userId,
    required this.parentCommentId,
    required this.createdAt,
  });
  

  ReplyComment copyWith({
    String? reply,
    String? id,
    String? userId,
    String? parentCommentId,
    DateTime? createdAt,
  }) {
    return ReplyComment(
      reply: reply ?? this.reply,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reply': reply,
      'id': id,
      'userId': userId,
      'parentCommentId': parentCommentId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ReplyComment.fromMap(Map<String, dynamic> map) {
    return ReplyComment(
      reply: map['reply'] as String,
      id: map['id'] as String,
      userId: map['userId'] as String,
      parentCommentId: map['parentCommentId'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplyComment.fromJson(String source) => ReplyComment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReplyComment(reply: $reply, id: $id, userId: $userId, parentCommentId: $parentCommentId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ReplyComment other) {
    if (identical(this, other)) return true;
  
    return 
      other.reply == reply &&
      other.id == id &&
      other.userId == userId &&
      other.parentCommentId == parentCommentId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return reply.hashCode ^
      id.hashCode ^
      userId.hashCode ^
      parentCommentId.hashCode ^
      createdAt.hashCode;
  }
}
