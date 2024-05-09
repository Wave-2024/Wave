import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/database.dart';

class UserData {
  static Future<User> getUser({required String userID}) async {
    var userResponse = await Database.userDatabase.doc(userID).get();
    User user = User.fromMap(userResponse.data()!);
    return user;
  }

  static Future<User> createUser({required User user}) async {
    var userResponse =
        await Database.userDatabase.doc(user.id).set(user.toMap());
    return user;
  }

  static Future<CustomResponse> updateUser(
      {required String userId,
      required String name,
      required String username,
      required String bio}) async {
    CustomResponse customResponse;
    try {
      await Database.userDatabase
          .doc(userId)
          .update({'name': name, 'username': username, 'bio': bio});
      customResponse = CustomResponse(responseStatus: true);
    } on FirebaseException catch (e) {
      customResponse =
          CustomResponse(responseStatus: false, response: e.toString());
    }
    return customResponse;
  }
}
