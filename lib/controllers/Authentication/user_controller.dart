import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/data/story_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/post_content_model.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/story_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/services/storage_service.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/util_functions.dart';

class UserDataController extends ChangeNotifier {
  int otherProfileViewOptions = 0;
  User? user;
  USER userState = USER.ABSENT;
  FETCH_SELF_POST fetch_self_post = FETCH_SELF_POST.NOT_FETCHED;

  FOLLOWING_USER following_user = FOLLOWING_USER.IDLE;
  int profilePostViewingOptions = 0;
  List<User> searchedUsers = [];
  Map<String, User> otherUsers = {};
  Map<POST_TYPE, Set<Post>> selfPosts = {};

  Map<String, Story> feedStories = {};

  FETCH_FEED_STORY fetch_feed_story = FETCH_FEED_STORY.NOT_FETCHED;

  bool isUploadingStory = false;

  void startUploadingStory() {
    isUploadingStory = true;
    notifyListeners();
  }

  void finishUploadingStory() {
    isUploadingStory = false;
    notifyListeners();
  }

  Future<void> fetchFeedStories() async {
    fetch_feed_story = FETCH_FEED_STORY.FETCHING;
    await Future.delayed(Duration.zero);
    notifyListeners();
    List<dynamic> following = user!.following;
    for (var index = 0; index < following.length; ++index) {
      CustomResponse response =
          await StoryData.fetchMyStory(userId: following[index]);
      if (response.responseStatus) {
        Story story = response.response as Story;
        feedStories[following[index]] = story;
      }
    }
    fetch_feed_story = FETCH_FEED_STORY.FETCHED;
    notifyListeners();
  }

  UserDataController() {
    selfPosts[POST_TYPE.IMAGE] = {};
    selfPosts[POST_TYPE.VIDEO] = {};
    selfPosts[POST_TYPE.TEXT] = {};
  }

  Future<void> getAllPosts() async {
    if (fetch_self_post != FETCH_SELF_POST.FETCHING) {
      fetch_self_post = FETCH_SELF_POST.FETCHING;
      await Future.delayed(
          Duration.zero); // Not sure if this is needed, but keeping it

      StreamSubscription<Post>? sub;

      sub = fetchPostStreamUsingPostId(user!.posts).listen(
        (post) {
          if (post.postList.isEmpty) {
            selfPosts[POST_TYPE.TEXT]!.add(post);
          } else {
            Post imagePost = Post(
                id: post.id,
                postList: [],
                createdAt: post.createdAt,
                userId: post.userId,
                caption: post.caption,
                mentions: post.mentions);
            Post videoPost = Post(
                id: post.id,
                postList: [],
                createdAt: post.createdAt,
                userId: post.userId,
                caption: post.caption,
                mentions: post.mentions);
            List<PostContent> imagePostList = [];
            List<PostContent> videoPostList = [];

            for (var index = 0; index < post.postList.length; ++index) {
              if (post.postList[index].type == 'image') {
                imagePostList.add(post.postList[index]);
              } else {
                videoPostList.add(post.postList[index]);
              }
            }

            if (imagePostList.isNotEmpty) {
              imagePost = imagePost.copyWith(postList: imagePostList);
              selfPosts[POST_TYPE.IMAGE]!.add(imagePost);
            }
            if (videoPostList.isNotEmpty) {
              videoPost = imagePost.copyWith(postList: videoPostList);
              selfPosts[POST_TYPE.VIDEO]!.add(videoPost);
            }
          }
        },
        onDone: () {
          sub!.cancel();
          fetch_self_post = FETCH_SELF_POST.FETCHED;
          notifyListeners();
          'All posts done'.printInfo();
        },
        onError: (error) {
          fetch_self_post = FETCH_SELF_POST.FETCHED;
          notifyListeners();
          print('Error fetching posts: $error');
          sub!.cancel();
        },
      );
    }
  }

  // Stream function to fetch posts concurrently by their IDs
  Stream<Post> fetchPostStreamUsingPostId(List<dynamic> postIdList) async* {
    List<Future<Post>> futures =
        postIdList.map((postId) => PostData.getPost(postId)).toList();

    // Use Future.wait to wait for all futures to complete and handle errors
    List<Future<Post?>> completedFutures = futures.map((future) async {
      try {
        return await future;
      } catch (e) {
        print('Error fetching post: $e');
        return null; // Handle error, return null or use an alternative approach
      }
    }).toList();

    List<Post?> results = await Future.wait(completedFutures);

    for (var post in results) {
      if (post != null) {
        yield post;
      }
    }
  }

  bool otherUserDataPresent(String otherUserId) =>
      otherUsers.containsKey(otherUserId);

  bool followingUser(String otherUserId) =>
      user!.following.contains(otherUserId);

  Future<CustomResponse?> followUser(String otherUserId) async {
    if (following_user == FOLLOWING_USER.FOLLOWING) {
      "In process of following".printInfo();
      return null;
    }
    following_user = FOLLOWING_USER.FOLLOWING;
    await Future.delayed(Duration.zero);
    notifyListeners();
    List<dynamic> followingList = user!.following;
    List<dynamic> followerList =
        (await UserData.getUser(userID: otherUserId)).followers;

    // Increase current user's followings
    followingList.add(otherUserId);
    CustomResponse customResponse =
        await UserData.updateUser(userId: user!.id, following: followingList);

    if (customResponse.responseStatus) {
      "Followed".printInfo();
      user!.copyWith(following: followingList);
    }

    // Increasing other user's followers
    followerList.add(user!.id);
    customResponse =
        await UserData.updateUser(userId: otherUserId, followers: followerList);

    otherUsers[otherUserId] = await UserData.getUser(userID: otherUserId);

    following_user = FOLLOWING_USER.IDLE;
    notifyListeners();

    return customResponse;
  }

  Future<CustomResponse?> unFollowUser(String otherUserId) async {
    if (following_user == FOLLOWING_USER.FOLLOWING) {
      "In process of following/unfollowing".printInfo();
      return null;
    }
    following_user = FOLLOWING_USER.FOLLOWING;
    await Future.delayed(Duration.zero);
    notifyListeners();
    List<dynamic> followingList = user!.following;
    List<dynamic> followerList =
        (await UserData.getUser(userID: otherUserId)).followers;

    // Decrease current user's followings
    followingList.remove(otherUserId);
    CustomResponse customResponse =
        await UserData.updateUser(userId: user!.id, following: followingList);

    if (customResponse.responseStatus) {
      "UnFollowed".printInfo();
      user!.copyWith(following: followingList);
    }

    // Decreasing other user's followers
    followerList.remove(user!.id);
    customResponse =
        await UserData.updateUser(userId: otherUserId, followers: followerList);

    otherUsers[otherUserId] = await UserData.getUser(userID: otherUserId);

    following_user = FOLLOWING_USER.IDLE;
    notifyListeners();

    return customResponse;
  }

  Future<void> updateOtherUserData(String otherUserId) async {
    otherUsers[otherUserId] = await UserData.getUser(userID: otherUserId);
    notifyListeners();
  }

  void changeOtherProfileViewOptions(int index) {
    otherProfileViewOptions = index;
    notifyListeners();
  }

  Future<void> setUser({String? userID, User? user, String? name}) async {
    if (userState != USER.LOADING) {
      userState = USER.LOADING;
      await Future.delayed(Duration.zero);
      notifyListeners();
    }

    if (userID != null) {
      printInfo(info: "User id received ${userID}");
      this.user = await UserData.getUser(userID: userID);
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != this.user!.fcmToken) {
        StreamSubscription<CustomResponse>? sub;
        sub = updateProfile(fcmToken: fcmToken).listen(
          (customRes) {
            if (customRes.responseStatus) {
              "Modified fcm key".printInfo();
            }
          },
          onDone: () {
            sub!.cancel();
          },
        );
      }

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
    Set<User> users = {};
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
      if (!users.contains(foundUser)) {
        users.add(foundUser);
      }
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
      if (!users.contains(foundUser)) {
        users.add(foundUser);
      }
    }

    printInfo(info: "set of searched users : ${users.length}");

    searchedUsers = users.toList();
    printInfo(info: "Number of users found : ${searchedUsers.length}");
    notifyListeners();
  }

  Stream<CustomResponse> updateProfile(
      {String? name,
      String? bio,
      String? fcmToken,
      String? username,
      String? newPostId,
      CroppedFile? coverPicture,
      CroppedFile? displayPicture}) async* {
    // First, update the user's text data
    if (newPostId != null) {
      // user has posted recently
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Add post ID to the user's posts array
        transaction.update(Database.userDatabase.doc(user!.id), {
          'posts': FieldValue.arrayUnion([newPostId])
        });
      });
      user = await UserData.getUser(userID: user!.id);
      notifyListeners();
    }

    CustomResponse customResponse = await UserData.updateUser(
        userId: user!.id,
        fcmToken: fcmToken ?? user!.fcmToken,
        name: name ?? user!.name,
        username: username ?? user!.username,
        bio: bio ?? user!.bio ?? "");

    if (customResponse.responseStatus) {
      // Update local user instance if the text update is successful
      user = user!.copyWith(
          bio: bio, name: name, username: username, fcmToken: fcmToken);
      "proile getting updated from here".printInfo();
      notifyListeners();
      yield customResponse; // Yield the result of the text update
    } else {
      yield customResponse; // Yield the failure response and return early
      return;
    }

    // Prepare to upload images if provided
    List<Future<CustomResponse>> uploadTasks = [];

    if (displayPicture != null) {
      "Display picture is not null".printInfo();
      uploadTasks
          .add(uploadImage(file: displayPicture, type: 'displayPicture'));
    }
    if (coverPicture != null) {
      "Cover picture is not null".printInfo();

      uploadTasks.add(uploadImage(file: coverPicture, type: 'coverPicture'));
    }

    // Execute image uploads in parallel
    if (uploadTasks.isNotEmpty) {
      List<CustomResponse> responses = await Future.wait(uploadTasks);

      // Yield each upload response
      for (CustomResponse response in responses) {
        yield response;
      }
    }
  }

  Future<CustomResponse> uploadImage(
      {required CroppedFile file, required String type}) async {
    // Mock implementation of the upload process
    try {
      // Assume a function that uploads the file and returns a URL or error
      // Update user profile with new image URL
      if (type == 'displayPicture') {
        String? imageUrl = await getImageUrl(
            File(file.path), "users/${user!.id}/displayPicture");

        if (imageUrl != null) {
          CustomResponse customResponse = await UserData.updateUser(
              userId: user!.id, displayPicture: imageUrl);
          if (customResponse.responseStatus) {
            user = user!.copyWith(displayPicture: imageUrl);
          } else {
            return customResponse;
          }
        } else {
          "No response from server ?".printError();
        }
      } else if (type == 'coverPicture') {
        String? imageUrl = await getImageUrl(
            File(file.path), "users/${user!.id}/coverPicture");
        if (imageUrl != null) {
          CustomResponse customResponse = await UserData.updateUser(
              userId: user!.id, coverPicture: imageUrl);
          if (customResponse.responseStatus) {
            user = user!.copyWith(coverPicture: imageUrl);
          } else {
            return customResponse;
          }
        }
      }
      String message = type == "coverPicture"
          ? "Your cover photo has been updated successfully"
          : "Your profile picture has been updated successfully";
      return CustomResponse(responseStatus: true, response: message);
    } catch (e) {
      return CustomResponse(
          responseStatus: false, response: "Upload failed: $e");
    }
  }

  Future<CustomResponse> savePost(String postId) async {
    CustomResponse response =
        await UserData.savePost(userId: user!.id, postId: postId);

    if (response.responseStatus) {
      // Update the local user instance
      List<dynamic> updatedSavedPosts = List.from(user!.savedPosts ?? []);
      if (!updatedSavedPosts.contains(postId)) {
        updatedSavedPosts.add(postId);
        user = user!.copyWith(savedPosts: updatedSavedPosts);
        notifyListeners();
      }
    }
    return response;
  }

  Future<CustomResponse> unsavePost(String postId) async {
    CustomResponse response =
        await UserData.unsavePost(userId: user!.id, postId: postId);

    if (response.responseStatus) {
      // Update the local user instance
      List<dynamic> updatedSavedPosts = List.from(user!.savedPosts ?? []);
      if (updatedSavedPosts.contains(postId)) {
        updatedSavedPosts.remove(postId);
        user = user!.copyWith(savedPosts: updatedSavedPosts);
        notifyListeners();
      }
    }
    return response;
  }
}
