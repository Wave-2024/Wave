import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:nexus/utils/widgets.dart';

class usersProvider extends ChangeNotifier {
  Map<String, PostModel> postToDisplay = {};

  Map<String, PostModel> thisUserPosts = {};

  Map<String, PostModel> get fetchThisUserPosts {
    return thisUserPosts;
  }

  Map<String, NexusUser> allUsers = {};

  Map<String, PostModel> get fetchPostsToDisplay {
    return postToDisplay;
  }

  Map<String, NexusUser> get fetchAllUsers {
    return allUsers;
  }

  Future<void> addCommentToThePost(
      String postId, String ownerId, String myId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc()
        .set({
      'comment': comment,
      'timestamp': Timestamp.now(),
      'uid': myId,
    });
  }

  Future<void> deleteCommentFromThisPost(
      String postId, String commentId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  Future<void> setAllUsers() async {
    final String api = constants().fetchApi + 'users.json';
    Map<String, NexusUser> temp = {};
    try {
      final userResponse = await http.get(Uri.parse(api));
      final userData = json.decode(userResponse.body) as Map<String, dynamic>;
      userData.forEach((key, value) {
        temp[key] = NexusUser(
            bio: value['bio'],
            coverImage: value['coverImage'],
            dp: value['dp'],
            email: value['email'],
            followers: value['followers'] ?? [],
            followings: value['followings'] ?? [],
            title: value['title'],
            uid: key,
            username: value['username']);
      });
      allUsers = temp;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> setFeedPosts(String myUid) async {
    print('reached setFeed Post Function');

    List<dynamic> myFollowings = [];
    List<PostModel> tempPosts = [];
    Map<String, PostModel> finalPosts = {};
    final String api = constants().fetchApi + 'users/${myUid}.json';
    final response = await http.get(Uri.parse(api));
    final user = json.decode(response.body) as Map<String, dynamic>;
    myFollowings = user['followings'] ?? [];
    for (int index = 0; index < myFollowings.length; ++index) {
      print('entering loop');
      final String api3 =
          constants().fetchApi + 'posts/${myFollowings[index].toString()}.json';
      final postsResponse = await http.get(Uri.parse(api3));
      if (json.decode(postsResponse.body) != null) {
        final postsData =
            json.decode(postsResponse.body) as Map<String, dynamic>;
        postsData.forEach((key, value) {
          tempPosts.add(PostModel(
              dateOfPost: value['dateOfPost'],
              caption: value['caption'],
              image: value['image'],
              uid: value['uid'],
              post_id: key,
              likes: value['likes'] ?? []));
        });
        for (int run = 0; run < tempPosts.length; ++run) {
          finalPosts[tempPosts[run].post_id] = tempPosts[run];
        }
      }
    }
    postToDisplay = finalPosts;
    notifyListeners();
  }

  Future<void> addCoverPicture(File? newImage, String uid) async {
    String imageLocation = 'users/${uid}/details/cp';
    NexusUser? oldUser = allUsers[uid];
    NexusUser? updateUser;

    final Reference storageReference =
        FirebaseStorage.instance.ref().child(imageLocation);
    final UploadTask uploadTask = storageReference.putFile(newImage!);
    final TaskSnapshot taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL().then((value) async {
      final String api = constants().fetchApi + 'users/${uid}.json';
      try {
        await http
            .patch(Uri.parse(api), body: jsonEncode({'coverImage': value}))
            .then((_) {
          updateUser = NexusUser(
              bio: oldUser!.bio,
              coverImage: value,
              dp: oldUser.dp,
              email: oldUser.email,
              followers: oldUser.followers,
              followings: oldUser.followings,
              title: oldUser.title,
              uid: uid,
              username: oldUser.username);
          allUsers[uid] = updateUser!;
          notifyListeners();
        });
      } catch (error) {
        print(error);
      }
    });
  }

  Future<void> addProfilePicture(File? newImage, String uid) async {
    String imageLocation = 'users/${uid}/details/dp';
    NexusUser? oldUser = allUsers[uid];
    NexusUser? updateUser;
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(imageLocation);
    final UploadTask uploadTask = storageReference.putFile(newImage!);
    final TaskSnapshot taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL().then((value) async {
      final String api = constants().fetchApi + 'users/${uid}.json';
      try {
        http
            .patch(Uri.parse(api), body: jsonEncode({'dp': value}))
            .then((value) {
          updateUser = NexusUser(
              bio: oldUser!.bio,
              coverImage: oldUser.coverImage,
              dp: value.toString(),
              email: oldUser.email,
              followers: oldUser.followers,
              followings: oldUser.followings,
              title: oldUser.title,
              uid: uid,
              username: oldUser.username);
          allUsers[uid] = updateUser!;
          notifyListeners();
        });
      } catch (error) {
        print(error);
      }
    });
  }

  Future<void> editMyProfile(
      String uid, String fullName, String userName, String bio) async {
    final String api = constants().fetchApi + 'users/${uid}.json';
    NexusUser? oldUser = allUsers[uid];
    NexusUser? updateUser;
    try {
      http
          .patch(Uri.parse(api),
              body: jsonEncode({
                'title': fullName,
                'username': userName,
                'bio': bio,
              }))
          .then((value) {
        updateUser = NexusUser(
            bio: bio,
            coverImage: oldUser!.coverImage,
            dp: oldUser.dp,
            email: oldUser.email,
            followers: oldUser.followers,
            followings: oldUser.followings,
            title: fullName,
            uid: uid,
            username: userName);
        allUsers[uid] = updateUser!;
        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> followUser(String myUid, String personUid) async {
    List<dynamic> followings;
    List<dynamic> followers;
    String? chatId;

    NexusUser? thisUser = allUsers[personUid];
    NexusUser? myOldProfile = allUsers[myUid];

    try {
      // Generating chat ID
      chatId = generateChatRoomUsingUid(myUid, personUid);

      // fetch details of user 1 -> START
      final String api1 = constants().fetchApi + 'users/${myUid}.json';
      final responseForUser1 = await http.get(Uri.parse(api1));
      final dataForUser1 =
          json.decode(responseForUser1.body) as Map<String, dynamic>;

      followings = dataForUser1['followings'] ?? [];
      // Increase my followings
      followings.add(personUid);

      allUsers[myUid] = NexusUser(
        dp: myOldProfile!.dp,
        title: myOldProfile.title,
        bio: myOldProfile.bio,
        email: myOldProfile.email,
        uid: myOldProfile.uid,
        coverImage: myOldProfile.coverImage,
        followers: myOldProfile.followers,
        followings: followings,
        username: myOldProfile.username,
      );

      // Set chat id to my cloudstore

      // Check if it already exists

      var userDocRef = FirebaseFirestore.instance.collection(myUid).doc(chatId);
      var doc = await userDocRef.get();
      if (!doc.exists) {
        await FirebaseFirestore.instance.collection(myUid).doc(chatId).set({
          'chatId': chatId,
          'lastSent': Timestamp.now(),
          'uid': personUid,
          'chatbg': -1,
        });
      } else {
        debugPrint('Already exists');
      }

      // Update to Server for User1

      await http.patch(Uri.parse(api1),
          body: json.encode({'followings': followings}));

      // User 1 operations -> END

      // fetch details of user 2 -> START
      final String api2 = constants().fetchApi + 'users/${personUid}.json';
      final responseForUser2 = await http.get(Uri.parse(api2));
      final dataForUser2 =
          json.decode(responseForUser2.body) as Map<String, dynamic>;
      followers = dataForUser2['followers'] ?? [];

      // Increase their followers
      followers.add(myUid);

      allUsers[personUid] = NexusUser(
        dp: thisUser!.dp,
        title: thisUser.title,
        bio: thisUser.bio,
        email: thisUser.email,
        uid: thisUser.uid,
        coverImage: thisUser.coverImage,
        followers: followers,
        followings: thisUser.followings,
        username: thisUser.username,
      );

      // Set chat id to person's cloudstore

      var userDocRef2 =
          FirebaseFirestore.instance.collection(personUid).doc(chatId);
      var doc2 = await userDocRef2.get();
      if (!doc2.exists) {
        await FirebaseFirestore.instance.collection(personUid).doc(chatId).set({
          'chatId': chatId,
          'lastSent': Timestamp.now(),
          'uid': myUid,
          'chatbg':-1,
        });
      } else {
        debugPrint('Already exists');
      }

      // Update to the server
      await http.patch(Uri.parse(api2),
          body: json.encode({
            'followers': followers,
          }));

      // Operation on User 2 -> END

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> unFollowUser(String myUid, String personUid) async {
    NexusUser? thisUser = allUsers[personUid];
    NexusUser? myOldProfile = allUsers[myUid];
    List<dynamic> followings;
    List<dynamic> followers;

    try {
      final String api1 = constants().fetchApi + 'users/${myUid}.json';
      final responseForUser1 = await http.get(Uri.parse(api1));
      final dataForUser1 =
          json.decode(responseForUser1.body) as Map<String, dynamic>;

      followings = dataForUser1['followings'] ?? [];
      // decrease my followings
      followings.remove(personUid);

      allUsers[myUid] = NexusUser(
        dp: myOldProfile!.dp,
        title: myOldProfile.title,
        bio: myOldProfile.bio,
        email: myOldProfile.email,
        uid: myOldProfile.uid,
        coverImage: myOldProfile.coverImage,
        followers: myOldProfile.followers,
        followings: followings,
        username: myOldProfile.username,
      );

      await http.patch(Uri.parse(api1),
          body: json.encode({'followings': followings}));
      // User 1 operations -> END

      final String api2 = constants().fetchApi + 'users/${personUid}.json';
      final responseForUser2 = await http.get(Uri.parse(api2));
      final dataForUser2 =
          json.decode(responseForUser2.body) as Map<String, dynamic>;
      followers = dataForUser2['followers'] ?? [];

      // Decrease their followers
      followers.remove(myUid);
      allUsers[personUid] = NexusUser(
        dp: thisUser!.dp,
        title: thisUser.title,
        bio: thisUser.bio,
        email: thisUser.email,
        uid: thisUser.uid,
        coverImage: thisUser.coverImage,
        followers: followers,
        followings: thisUser.followings,
        username: thisUser.username,
      );
      await http.patch(Uri.parse(api2),
          body: json.encode({
            'followers': followers,
          }));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addNewPost(String caption, String uid, File image) async {
    final String api = constants().fetchApi + 'posts/${uid}.json';
    try {
      var random = Random();
      DateTime datetime = DateTime.now();
      String day = datetime.day.toString();
      String year = datetime.year.toString();
      String month = datetime.month.toString();
      final String dateOfPost = '${day}/${month}/${year}';
      int random1 = random.nextInt(999999);
      int random2 = random.nextInt(555555);
      int random3 = random.nextInt(101);
      int random4 = random.nextInt(540);
      final String name = '${random1}${random2}${random3}${random4}';
      final String location = '${uid}${name}';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(location);
      final UploadTask uploadTask = storageReference.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then((value) async {
        http
            .post(Uri.parse(api),
                body: json.encode({
                  'caption': caption,
                  'image': value,
                  'uid': uid,
                  'likes': [],
                  'dateOfPost': dateOfPost,
                }))
            .then((v) {
          final postData = json.decode(v.body) as Map<String, dynamic>;
          thisUserPosts[postData['name']] = PostModel(
              caption: caption,
              dateOfPost: dateOfPost,
              image: value,
              uid: uid,
              post_id: postData['name'],
              likes: []);
          notifyListeners();
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> deletePost(String postId) async {
    final String api = constants().fetchApi + 'posts/$postId.json';
    try {
      await http.delete(Uri.parse(api)).then((value) {
        FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      });
      thisUserPosts.remove(postId);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> likeThisPostFromFeed(
      String myUid, String userUid, String postUid) async {
    final String api =
        constants().fetchApi + 'posts/${userUid}/${postUid}.json';
    List<dynamic> likes = [];
    try {
      likes = postToDisplay[postUid]!.likes;
      likes.add(myUid);
      PostModel? tempPostModel = postToDisplay[postUid];
      PostModel p = PostModel(
          caption: tempPostModel!.caption,
          dateOfPost: tempPostModel.dateOfPost,
          image: tempPostModel.image,
          uid: tempPostModel.uid,
          post_id: tempPostModel.post_id,
          likes: likes);
      postToDisplay[postUid] = p;
      notifyListeners();
      await http.patch(Uri.parse(api), body: json.encode({'likes': likes}));
    } catch (error) {
      print(error);
    }
  }

  Future<void> likeThisPostFromThisUserProfile(
      String myUid, String userUid, String postUid) async {
    final String api =
        constants().fetchApi + 'posts/${userUid}/${postUid}.json';
    List<dynamic> likes = [];
    try {
      likes = thisUserPosts[postUid]!.likes;
      likes.add(myUid);
      PostModel? tempPostModel = thisUserPosts[postUid];
      PostModel p = PostModel(
          caption: tempPostModel!.caption,
          dateOfPost: tempPostModel.dateOfPost,
          image: tempPostModel.image,
          uid: tempPostModel.uid,
          post_id: tempPostModel.post_id,
          likes: likes);
      thisUserPosts[postUid] = p;
      notifyListeners();
      await http.patch(Uri.parse(api), body: json.encode({'likes': likes}));
    } catch (error) {
      print(error);
    }
  }

  Future<void> disLikeThisPostFromFeed(
      String myUid, String userUid, String postUid) async {
    final String api =
        constants().fetchApi + 'posts/${userUid}/${postUid}.json';
    List<dynamic> likes = [];
    try {
      likes = postToDisplay[postUid]!.likes;
      likes.remove(myUid);
      PostModel? tempPostModel = postToDisplay[postUid];
      PostModel p = PostModel(
          caption: tempPostModel!.caption,
          dateOfPost: tempPostModel.dateOfPost,
          image: tempPostModel.image,
          uid: tempPostModel.uid,
          post_id: tempPostModel.post_id,
          likes: likes);
      postToDisplay[postUid] = p;
      notifyListeners();
      await http.patch(Uri.parse(api), body: json.encode({'likes': likes}));
    } catch (error) {
      print(error);
    }
  }

  Future<void> disLikePostFromThisUserProfile(
      String myUid, String userUid, String postUid) async {
    final String api =
        constants().fetchApi + 'posts/${userUid}/${postUid}.json';
    List<dynamic> likes = [];
    try {
      likes = thisUserPosts[postUid]!.likes;
      likes.remove(myUid);
      PostModel? tempPostModel = thisUserPosts[postUid];
      PostModel p = PostModel(
          caption: tempPostModel!.caption,
          dateOfPost: tempPostModel.dateOfPost,
          image: tempPostModel.image,
          uid: tempPostModel.uid,
          post_id: tempPostModel.post_id,
          likes: likes);
      thisUserPosts[postUid] = p;
      notifyListeners();
      await http.patch(Uri.parse(api), body: json.encode({'likes': likes}));
    } catch (error) {
      print(error);
    }
  }

  Future<void> setPostsForThisProfile(String uid) async {
    final api = constants().fetchApi + 'posts/${uid}.json';
    Map<String, PostModel> temp = {};
    try {
      final response = await http.get(Uri.parse(api));
      if (json.decode(response.body) != null) {
        final data2 = json.decode(response.body) as Map<String, dynamic>;
        data2.forEach((key, value) {
          temp[key] = PostModel(
              dateOfPost: value['dateOfPost'],
              caption: value['caption'],
              image: value['image'],
              uid: uid,
              post_id: key,
              likes: value['likes'] ?? []);
        });
      }
      thisUserPosts = temp;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
