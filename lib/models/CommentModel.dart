class CommentModel {
  final String commentId;
  final String uid;
  final String userDp;
  final String userName;
  final String comment;
  final String dateOfComment;

  CommentModel({
    required this.userDp,
    required this.userName,
    required this.dateOfComment,
    required this.commentId,
    required this.comment,
    required this.uid,
  });
}
