import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;

class usersProvider extends ChangeNotifier {
  List<NexusUser> searchUsers = [];
  NexusUser? currentUser;
  Map<String, NexusUser> followers =
      {}; // map to store uid as key and user model as value
  Map<String, NexusUser> get fetchFollowers {
    // function to return the user map
    return followers;
  }

  List<NexusUser> get fetchSearchList {
    return [...searchUsers];
  }

  Future<void> addFollower(String myUid, String personUid) async {
    NexusUser myProfile;
    NexusUser peopleProfile;
    List<dynamic> followings;
    List<dynamic> followers;
    final String api1 = constants().fetchApi +
        'users/${myUid}.json'; // Api to increase my followings
    final String api2 = constants().fetchApi +
        'users/${personUid}.json'; // Api to increase their followers
    try {
      final response = await http.get(Uri.parse(api1));
      final data = json.decode(response.body) as Map<String, dynamic>;
      myProfile = NexusUser(
        title: data['title'],
        coverImage: data['coverImage'],
        uid: myUid,
        username: data['username'],
        email: data['email'],
        bio: data['bio'],
        dp: data['dp'],
        followers: data['followers'] ?? [],
        followings: data['followings'] ?? [],
        posts: data['posts'] ?? [],
      );
      followings = myProfile.followings;
      followings.add(personUid);
      await http.patch(Uri.parse(api1),
          body: json.encode({'followings': followings}));
      final response2 = await http.get(Uri.parse(api2));
      final data2 = json.decode(response.body) as Map<String, dynamic>;
      peopleProfile = NexusUser(
        title: data['title'],
        coverImage: data['coverImage'],
        uid: myUid,
        username: data['username'],
        email: data['email'],
        bio: data['bio'],
        dp: data['dp'],
        followers: data['followers'] ?? [],
        followings: data['followings'] ?? [],
        posts: data['posts'] ?? [],
      );
      followers = peopleProfile.followers;
      followers.add(myUid);
      await http.patch(Uri.parse(api2),
          body: json.encode({
            'followers': followers,
          }));
    } catch (error) {
      print(error);
    }
  }

  Map<String, NexusUser> followings = {};

  Future<void> setUsers() async {
    final String api = constants().fetchApi + 'users.json';
    List<NexusUser> temp = [];
    try {
      final response = await http.get(Uri.parse(api));
      final data = json.decode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        temp.add(NexusUser(
            title: value['title'],
            posts: value['posts'] ?? [],
            coverImage: value['coverImage'],
            uid: key,
            username: value['username'],
            email: value['email'],
            bio: value['bio'],
            dp: value['dp'],
            followers: value['followers'] ?? [],
            followings: value['followings'] ?? []));
      });
      searchUsers = temp;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

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
