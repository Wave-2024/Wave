import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/util_functions.dart';

class CreatePostController extends ChangeNotifier {
  CREATE_POST create_post = CREATE_POST.IDLE;
  List<User> mentionedUsers = [];
  List<User> searchedUsers = [];
  List<File> selectedMediaFiles = [];

  void resetController() {
    create_post = CREATE_POST.IDLE;
    mentionedUsers = [];
    searchedUsers = [];
    selectedMediaFiles = [];
    notifyListeners();
  }

  void addMediaFiles(List<XFile> files) {
    for (var index = 0; index < files.length; ++index) {
      selectedMediaFiles.add(File(files[index].path));
    }

    notifyListeners();
  }

  Future<CustomResponse> createNewPost(
      {required String userId, String? caption}) async {
    create_post = CREATE_POST.CREATING;
    await Future.delayed(Duration.zero);
    notifyListeners();
    Post post = Post(
        id: "",
        postList: [],
        createdAt: DateTime.now(),
        userId: userId,
        caption: "caption",
        mentions: []);

    var res = await Database.postDatabase.add(post.toMap());
    String postId = res.id;

    post = await PostData.createPostModel(
        userId: userId,
        caption: caption,
        id: postId,
        mediaFiles: selectedMediaFiles,
        mentionedUsers: mentionedUsers);
    try {
      await Database.postDatabase.doc(postId).update(post.toMap());
      create_post = CREATE_POST.IDLE;
      notifyListeners();
      return CustomResponse(responseStatus: true,response: postId);
    } on FirebaseException catch (e) {
      create_post = CREATE_POST.IDLE;
      notifyListeners();
      return CustomResponse(responseStatus: false, response: e.toString());
    }
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
