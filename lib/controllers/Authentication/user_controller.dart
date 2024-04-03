import 'package:flutter/material.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/enums.dart';

class UserController extends ChangeNotifier {
  User? user;
  USER userState = USER.ABSENT;

  Future<void> setUser({required String userID}) async {
    userState = USER.LOADING;
    await Future.delayed(Duration.zero);
    notifyListeners();
    user = await UserData.getUser(userID: userID);
    userState = USER.PRESENT;
    notifyListeners();
  }
}
