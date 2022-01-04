import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;

class usersProvider extends ChangeNotifier {
  NexusUser? currentUser;
  Map<String, NexusUser> followers =
      {}; // map to store uid as key and user model as value
  Map<String, NexusUser> get fetchFollowers {
    // function to return the user map
    return followers;
  }

  Map<String, NexusUser> followings = {};

  Map<String, NexusUser> get fetchFollowings {
    // function to return the user map
    return followings;
  }

  NexusUser? get fetchCurrentUser {
    return currentUser;
  }

  Future<void> addNewPostTest(PostModel post, String uid) async {
    final String api = constants().fetchApi + 'users/${uid}.json';
    final List<dynamic> posts = currentUser!.posts;
    posts.add(post.toJson());
    http
        .patch(Uri.parse(api), body: json.encode({'posts': posts}))
        .then((value) {
      print(value.body.toString());
    });
  }

  Future<void> fetchUser(String uid) async {
    NexusUser? user;
    print('reached');
    final String api = constants().fetchApi + 'users/${uid}.json';
    try {
      final response = await http.get(Uri.parse(api));
      final data = json.decode(response.body) as Map<String, dynamic>;
      user = NexusUser(
        title: data['title'],
        coverImage: data['coverImage'],
        uid: uid,
        username: data['username'],
        email: data['email'],
        bio: data['bio'],
        dp: data['dp'],
        followers: data['followers'] ?? [],
        followings: data['followings'] ?? [],
        posts: data['posts'] ?? [],
      );
      print(user.title);
      currentUser = user;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
