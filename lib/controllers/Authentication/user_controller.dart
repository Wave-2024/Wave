import 'package:flutter/material.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/enums.dart';

class UserController extends ChangeNotifier {
  User? user;
  USER userState = USER.ABSENT;

  Future<void> setUser({String? userID, User? user}) async {
    if (userState != USER.LOADING) {
      userState = USER.LOADING;
    }
    await Future.delayed(Duration.zero);
    notifyListeners();
    if (userID != null) {
      this.user = await UserData.getUser(userID: userID);
      userState = USER.PRESENT;
    } else {
      this.user = user!;
    }
    notifyListeners();
  }

  Future<void> createUser({required User user}) async {
    userState = USER.LOADING;
    await Future.delayed(Duration.zero);
    notifyListeners();
    await UserData.createUser(user: user);
    await setUser(user: user);
  }
}
