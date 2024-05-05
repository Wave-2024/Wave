import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/database.dart';

class UserData {
  static Future<User> getUser({required String userID}) async {
    
    var userResponse = await Database.userDatabase.doc(userID).get();
    User user = User.fromMap(userResponse.data()!);
    return user;
  }

  static Future<User> createUser({required User user}) async {
    var userResponse = await Database.userDatabase.doc(user.id).set(user.toMap());
    return user;
  }
}
