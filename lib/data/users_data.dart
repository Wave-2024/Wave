import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants.dart';

class UserData {
  
  static Future<User> getUser({required String userID}) async {
    var userResponse = await database.doc(userID).get();
    User user = User.fromMap(userResponse.data()!);
    return user;
  }
  
}
