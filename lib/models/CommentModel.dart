import 'package:flutter/cupertino.dart';

class CommentModel {
  final String commentId;
  final String uid;
  final String comment;

  CommentModel({
    required this.commentId,
    required this.comment,
    required this.uid,
  });
}
