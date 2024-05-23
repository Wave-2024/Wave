import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/database_endpoints.dart';

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

  static Future<CustomResponse> updateUser({
    required String userId,
    String? name,
    String? username,
    String? bio,
    String? fcmToken,
    String? coverPicture,
    String? displayPicture,
    List<dynamic>? following,
    List<dynamic>? followers,
  }) async {
    try {
      Map<String, dynamic> dataToUpdate = {};

      // Only add fields that are not null to the map
      if (name != null) dataToUpdate['name'] = name;
      if (username != null) dataToUpdate['username'] = username;
      if (bio != null) dataToUpdate['bio'] = bio;
      if (coverPicture != null) dataToUpdate['coverPicture'] = coverPicture;
      if (displayPicture != null)
        dataToUpdate['displayPicture'] = displayPicture;
      if (following != null) dataToUpdate['following'] = following;
      if (followers != null) dataToUpdate['followers'] = followers;
      if (fcmToken != null) dataToUpdate['fcmToken'] = fcmToken;
      "I have reached here".printInfo();
      // Update the document in Firestore only if there's something to update
      if (dataToUpdate.isNotEmpty) {
        await Database.userDatabase.doc(userId).update(dataToUpdate);
        return CustomResponse(
            responseStatus: true, response: 'Update successful');
      } else {
        return CustomResponse(
            responseStatus: false, response: 'No data to update');
      }
    } on FirebaseException catch (e) {
      return CustomResponse(responseStatus: false, response: e.toString());
    }
  }
}
