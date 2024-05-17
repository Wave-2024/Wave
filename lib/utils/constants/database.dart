import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
static var postDatabase = FirebaseFirestore.instance.collection("posts");

static var userDatabase = FirebaseFirestore.instance.collection("users");
}