// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Notification {
  String type; // ['follow','like','comment','reply','mention']
  String id;
  DateTime createdAt;
  bool seen;
  String forUser;
  // Following notification details
  String? userWhoFollowed;
  // Comment notification details
  String? postId; // Common for all , likes, comment , and replies
  String? commentId;
  String? userWhoCommented;
  String? comment;
  // Reply notification details
  String? replyId;
  String? reply;
  String? userWhoReplied;
  // Like notification details
  String? likeId;
  String? userWhoLiked;
  // Mention notification details
  String? userWhoMentioned;
  Notification({
    required this.type,
    required this.id,
    required this.createdAt,
    required this.seen,
    required this.forUser,
    this.userWhoFollowed,
    this.postId,
    this.commentId,
    this.userWhoCommented,
    this.comment,
    this.replyId,
    this.reply,
    this.userWhoReplied,
    this.likeId,
    this.userWhoLiked,
    this.userWhoMentioned,
  });

  Notification copyWith({
    String? type,
    String? id,
    DateTime? createdAt,
    bool? seen,
    String? forUser,
    String? userWhoFollowed,
    String? postId,
    String? commentId,
    String? userWhoCommented,
    String? comment,
    String? replyId,
    String? reply,
    String? userWhoReplied,
    String? likeId,
    String? userWhoLiked,
    String? userWhoMentioned,
  }) {
    return Notification(
      type: type ?? this.type,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      seen: seen ?? this.seen,
      forUser: forUser ?? this.forUser,
      userWhoFollowed: userWhoFollowed ?? this.userWhoFollowed,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      userWhoCommented: userWhoCommented ?? this.userWhoCommented,
      comment: comment ?? this.comment,
      replyId: replyId ?? this.replyId,
      reply: reply ?? this.reply,
      userWhoReplied: userWhoReplied ?? this.userWhoReplied,
      likeId: likeId ?? this.likeId,
      userWhoLiked: userWhoLiked ?? this.userWhoLiked,
      userWhoMentioned: userWhoMentioned ?? this.userWhoMentioned,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'seen': seen,
      'forUser': forUser,
      'userWhoFollowed': userWhoFollowed,
      'postId': postId,
      'commentId': commentId,
      'userWhoCommented': userWhoCommented,
      'comment': comment,
      'replyId': replyId,
      'reply': reply,
      'userWhoReplied': userWhoReplied,
      'likeId': likeId,
      'userWhoLiked': userWhoLiked,
      'userWhoMentioned': userWhoMentioned,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      type: map['type'] as String,
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      seen: map['seen'] as bool,
      forUser: map['forUser'] as String,
      userWhoFollowed: map['userWhoFollowed'] != null ? map['userWhoFollowed'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      commentId: map['commentId'] != null ? map['commentId'] as String : null,
      userWhoCommented: map['userWhoCommented'] != null ? map['userWhoCommented'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      replyId: map['replyId'] != null ? map['replyId'] as String : null,
      reply: map['reply'] != null ? map['reply'] as String : null,
      userWhoReplied: map['userWhoReplied'] != null ? map['userWhoReplied'] as String : null,
      likeId: map['likeId'] != null ? map['likeId'] as String : null,
      userWhoLiked: map['userWhoLiked'] != null ? map['userWhoLiked'] as String : null,
      userWhoMentioned: map['userWhoMentioned'] != null ? map['userWhoMentioned'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notification(type: $type, id: $id, createdAt: $createdAt, seen: $seen, forUser: $forUser, userWhoFollowed: $userWhoFollowed, postId: $postId, commentId: $commentId, userWhoCommented: $userWhoCommented, comment: $comment, replyId: $replyId, reply: $reply, userWhoReplied: $userWhoReplied, likeId: $likeId, userWhoLiked: $userWhoLiked, userWhoMentioned: $userWhoMentioned)';
  }

  @override
  bool operator ==(covariant Notification other) {
    if (identical(this, other)) return true;
  
    return 
      other.type == type &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.seen == seen &&
      other.forUser == forUser &&
      other.userWhoFollowed == userWhoFollowed &&
      other.postId == postId &&
      other.commentId == commentId &&
      other.userWhoCommented == userWhoCommented &&
      other.comment == comment &&
      other.replyId == replyId &&
      other.reply == reply &&
      other.userWhoReplied == userWhoReplied &&
      other.likeId == likeId &&
      other.userWhoLiked == userWhoLiked &&
      other.userWhoMentioned == userWhoMentioned;
  }

  @override
  int get hashCode {
    return type.hashCode ^
      id.hashCode ^
      createdAt.hashCode ^
      seen.hashCode ^
      forUser.hashCode ^
      userWhoFollowed.hashCode ^
      postId.hashCode ^
      commentId.hashCode ^
      userWhoCommented.hashCode ^
      comment.hashCode ^
      replyId.hashCode ^
      reply.hashCode ^
      userWhoReplied.hashCode ^
      likeId.hashCode ^
      userWhoLiked.hashCode ^
      userWhoMentioned.hashCode;
  }
}
