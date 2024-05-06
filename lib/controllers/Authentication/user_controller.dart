import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/database.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/util_functions.dart';

class UserDataController extends ChangeNotifier {
  User? user;
  USER userState = USER.ABSENT;
  int profilePostViewingOptions = 0;
  List<User> searchedUsers = [];

  Future<void> setUser({String? userID, User? user}) async {
    if (userState != USER.LOADING) {
      userState = USER.LOADING;
      await Future.delayed(Duration.zero);
      notifyListeners();
    }

    if (userID != null) {
      printInfo(info: "User id received ${userID}");
      this.user = await UserData.getUser(userID: userID);
      userState = USER.PRESENT;
    } else {
      this.user = user!;
      userState = USER.PRESENT;
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

  void changePofileViewingOption(int updatedIndex) {
    profilePostViewingOptions = updatedIndex;
    notifyListeners();
  }

  Future<void> searchUsersByNameAndUserName(String searchString) async {
    List<User> users = [];
    if (searchString.isEmpty || searchString.length < 3) {
      printInfo(info: "Empty string");
      searchedUsers = [];
      notifyListeners();
      return;
    }
    String username = searchString;
    String name = capitalizeWords(searchString);
    // Calculate the end of the range by replacing the last character with the next Unicode character
    String endString = name.substring(0, name.length - 1) +
        String.fromCharCode(name.codeUnitAt(name.length - 1) + 1);

    // Search user by name (database)
    var searchUserResponse = await Database.userDatabase
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: endString)
        .get();
    for (var index = 0; index < searchUserResponse.docs.length; index++) {
      var doc = searchUserResponse.docs[index].data();
      User foundUser = User.fromMap(doc);
      users.add(foundUser);
    }

    endString = username.substring(0, username.length - 1) +
        String.fromCharCode(name.codeUnitAt(username.length - 1) + 1);
    // Search user by username (database)
    searchUserResponse = await Database.userDatabase
        .where('username', isGreaterThanOrEqualTo: username)
        .where('username', isLessThan: endString)
        .get();
    for (var index = 0; index < searchUserResponse.docs.length; index++) {
      var doc = searchUserResponse.docs[index].data();
      User foundUser = User.fromMap(doc);
      users.add(foundUser);
    }

    searchedUsers = users;
    printInfo(info: "Number of users found : ${searchedUsers.length}");
    notifyListeners();
  }
}
