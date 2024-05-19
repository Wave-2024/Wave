import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
static var postDatabase = FirebaseFirestore.instance.collection("posts");

static var userDatabase = FirebaseFirestore.instance.collection("users");

static CollectionReference getPostLikesDatabase(String postId){
  return FirebaseFirestore.instance.collection("posts").doc(postId).collection('likes');
}
}