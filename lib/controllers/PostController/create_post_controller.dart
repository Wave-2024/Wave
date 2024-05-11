import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/database.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/util_functions.dart';

class CreatePostController extends ChangeNotifier {
  CREATE_POST create_post = CREATE_POST.IDLE;
  List<User> mentionedUsers = [];
  Post? post;
  List<User> searchedUsers = [];
  List<File> selectedMediaFiles = [];

  void addMediaFiles(List<XFile> files) {
    for (var index = 0; index < files.length; ++index) {
      selectedMediaFiles.add(File(files[index].path));
    }

    notifyListeners();
  }

  Future<void> searchUserUsingQuery(String searchString) async {
    Set<User> users = {};
    if (searchString.isEmpty || searchString.length < 3) {
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
        .limit(20)
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
        .limit(20)
        .get();
    for (var index = 0; index < searchUserResponse.docs.length; index++) {
      var doc = searchUserResponse.docs[index].data();
      User foundUser = User.fromMap(doc);
      users.add(foundUser);
    }

    searchedUsers = users.toList();
    notifyListeners();
  }

  void toogleMentioningUser(User user) {
    if (mentionedUsers.contains(user)) {
      mentionedUsers.remove(user);
    } else {
      mentionedUsers.add(user);
    }
    notifyListeners();
  }
}
