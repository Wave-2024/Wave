import 'package:cloud_firestore/cloud_firestore.dart';

class Database {

static var userDatabase = FirebaseFirestore.instance.collection("users");
}