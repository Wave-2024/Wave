import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static var postDatabase = FirebaseFirestore.instance.collection("posts");

  static var userDatabase = FirebaseFirestore.instance.collection("users");

  static CollectionReference getPostLikesDatabase(String postId) {
    return postDatabase
        .doc(postId)
        .collection('likes');
  }

  static CollectionReference getPostCommentsDatabase(String postId) {
    return postDatabase.doc(postId).collection('comments');
  }

  static CollectionReference getPostCommentsLikesDatabase(
      String postId, String commentId) {
    return getPostCommentsDatabase(postId).doc(commentId).collection("likes");
  }

  static CollectionReference getNotificationDatabase(String userId) {
    return userDatabase.doc(userId).collection('notifications');
  }
}
