import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String uid;
  final String comment;
  final Timestamp time;

  CommentModel({
    required this.time,
    required this.commentId,
    required this.comment,
    required this.uid,
  });
}
