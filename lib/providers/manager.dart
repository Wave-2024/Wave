import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/CommentModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:nexus/utils/widgets.dart';

class usersProvider extends ChangeNotifier {
  Map<String, PostModel> postToDisplay = {};

  List<PostModel> thisProfilePosts = [];

  List<PostModel> get fetchThisProfilePosts {
    return [...thisProfilePosts];
  }

  Map<String, NexusUser> mapOfUsers = {};

  Map<String, PostModel> get fetchPostsToDisplay {
    return postToDisplay;
  }

  Future<void> setFeedPosts(String myUid) async {
    //print('reached setFeed Post Function');
    Map<String, NexusUser> tempMap = {};
    List<dynamic> myFollowings = [];
    List<PostModel> tempPosts = [];
    Map<String, PostModel> finalPosts = {};
    final String api = constants().fetchApi + 'users/${myUid}.json';
    final response = await http.get(Uri.parse(api));
    final user = json.decode(response.body) as Map<String, dynamic>;
    myFollowings = user['followings'] ?? [];
    for (int index = 0; index < myFollowings.length; ++index) {
      final String api2 =
          constants().fetchApi + 'users/${myFollowings[index].toString()}.json';
      final response2 = await http.get(Uri.parse(api2));
      final userData = json.decode(response2.body) as Map<String, dynamic>;
      NexusUser ne = NexusUser(
          title: userData['title'],
          coverImage: userData['coverImage'],
          uid: myFollowings[index].toString(),
          username: userData['username'],
          email: userData['email'],
          bio: userData['bio'],
          dp: userData['dp'],
          followers: userData['followers'] ?? [],
          followings: userData['followings'] ?? []);
      tempMap[myFollowings[index].toString()] = ne;
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
    mapOfUsers = tempMap;
    notifyListeners();
  }

  Map<String, dynamic> get fetchMapOfUsers {
    return mapOfUsers;
  }

  List<NexusUser> searchUsers = [];
  NexusUser? currentUser;

  List<NexusUser> get fetchSearchList {
    return [...searchUsers];
  }

  Future<void> addCoverPicture(File? newImage, String uid) async {
    String imageLocation = 'users/${uid}/details/cp';
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(imageLocation);
    final UploadTask uploadTask = storageReference.putFile(newImage!);
    final TaskSnapshot taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL().then((value) async {
      final String api = constants().fetchApi + 'users/${uid}.json';
      try {
        await http.patch(Uri.parse(api),
            body: jsonEncode({'coverImage': value}));
      } catch (error) {
        print(error);
      }
    });
  }

  Future<void> addProfilePicture(File? newImage, String uid) async {
    String imageLocation = 'users/${uid}/details/dp';
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(imageLocation);
    final UploadTask uploadTask = storageReference.putFile(newImage!);
    final TaskSnapshot taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL().then((value) async {
      final String api = constants().fetchApi + 'users/${uid}.json';
      try {
        await http.patch(Uri.parse(api), body: jsonEncode({'dp': value}));
      } catch (error) {
        print(error);
      }
    });
  }

  Future<void> editMyProfile(
      String uid, String fullName, String userName, String bio) async {
    final String api = constants().fetchApi + 'users/${uid}.json';
    try {
      await http.patch(Uri.parse(api),
          body: jsonEncode({
            'title': fullName,
            'username': userName,
            'bio': bio,
          }));
    } catch (error) {
      print(error);
    }
  }

  Future<void> addFollower(String myUid, String personUid) async {
    List<dynamic> followings;
    List<dynamic> followers;
    String? chatId;

    NexusUser? thatUser = await fetchAnyUser(personUid);
    NexusUser? myProfile = await fetchAnyUser(myUid);

    try {
      // Generating chat ID
      chatId = generateChatRoomUsingUid(myUid, personUid);

      // fetch details of user 1 -> START
      final String api1 = constants().fetchApi + 'users/${myUid}.json';
      final responseForUser1 = await http.get(Uri.parse(api1));
      final dataForUser1 =
          json.decode(responseForUser1.body) as Map<String, dynamic>;

      followings = dataForUser1['followings'] ?? [];
      // Increase my followings and my ChatKeys
      followings.add(personUid);
      // Set chat id to my cloudstore

      // Check if it already exists

      var userDocRef = FirebaseFirestore.instance.collection(myUid).doc(chatId);
      var doc = await userDocRef.get();
      if (!doc.exists) {
        await FirebaseFirestore.instance.collection(myUid).doc(chatId).set({
          'chatId': chatId,
          'lastSent': Timestamp.now(),
          'uid': personUid,
          'dp': thatUser!.dp,
          'userName': thatUser.username,
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

      // Increase their followers and add chatKey
      followers.add(myUid);

      // Set chat id to person's cloudstore

      var userDocRef2 =
          FirebaseFirestore.instance.collection(myUid).doc(chatId);
      var doc2 = await userDocRef2.get();
      if (!doc2.exists) {
        await FirebaseFirestore.instance.collection(personUid).doc(chatId).set({
          'chatId': chatId,
          'lastSent': Timestamp.now(),
          'uid': myUid,
          'userName': myProfile!.username,
          'dp': myProfile.dp,
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

    } catch (error) {
      print(error);
    }
  }

  Future<void> setUsers() async {
    final String api = constants().fetchApi + 'users.json';
    List<NexusUser> temp = [];
    try {
      final response = await http.get(Uri.parse(api));
      final data = json.decode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        temp.add(NexusUser(
            title: value['title'],
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

  PostModel? thisPost;

  PostModel? fetchThisPostDetails(String postId) {
    return postToDisplay[postId];
  }

  NexusUser? get fetchCurrentUser {
    return currentUser;
  }

  Future<void> removeFollower(String myUid, String personUid) async {
    NexusUser myProfile;
    NexusUser peopleProfile;
    List<dynamic> followings;
    List<dynamic> followers;
    final String api1 = constants().fetchApi +
        'users/${myUid}.json'; // Api to decrease my followings
    final String api2 = constants().fetchApi +
        'users/${personUid}.json'; // Api to decrease their followers
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
      );
      followings = myProfile.followings;
      followings.remove(personUid);
      await http.patch(Uri.parse(api1),
          body: json.encode({'followings': followings}));
      final response2 = await http.get(Uri.parse(api2));
      final data2 = json.decode(response2.body) as Map<String, dynamic>;
      peopleProfile = NexusUser(
        title: data2['title'],
        coverImage: data2['coverImage'],
        uid: personUid,
        username: data2['username'],
        email: data2['email'],
        bio: data2['bio'],
        dp: data2['dp'],
        followers: data2['followers'] ?? [],
        followings: data2['followings'] ?? [],
      );
      followers = peopleProfile.followers;
      followers.remove(myUid);
      await http.patch(Uri.parse(api2),
          body: json.encode({
            'followers': followers,
          }));
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
        await http.post(Uri.parse(api),
            body: json.encode({
              'caption': caption,
              'image': value,
              'uid': uid,
              'likes': [],
              'dateOfPost': dateOfPost,
            }));
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> likeThisPost(
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

  Future<void> disLikeThisPost(
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

  Future<void> fetchUser(String uid) async {
    NexusUser? user;
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
      );
      currentUser = user;
      List<PostModel> temp = [];
      final String api2 = constants().fetchApi + 'posts/${uid}.json';
      final response2 = await http.get(Uri.parse(api2));
      if (json.decode(response2.body) != null) {
        final data2 = json.decode(response2.body) as Map<String, dynamic>;
        data2.forEach((key, value) {
          temp.add(PostModel(
              dateOfPost: value['caption'],
              caption: value['caption'],
              image: value['image'],
              uid: uid,
              post_id: key,
              likes: value['likes'] ?? []));
        });
      }
      Map<String, NexusUser?> listOfChatRooms = {};

      thisProfilePosts = temp;

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  List<CommentModel> listOfCommentsForThisPosts = [];

  List<CommentModel> get fetchCommentsForThisPost {
    return [...listOfCommentsForThisPosts];
  }

  Future<void> setCommentsForThisPost(String postId) async {
    List<CommentModel> tempComments = [];
    final String api = constants().fetchApi + 'comments/${postId}.json';
    try {
      final commentResponse = await http.get(Uri.parse(api));
      if (json.decode(commentResponse.body) != null) {
        final commentData =
            json.decode(commentResponse.body) as Map<String, dynamic>;
        commentData.forEach((key, value) {
          tempComments.add(CommentModel(
              userName: value['userName'],
              userDp: value['userDp'],
              dateOfComment: value['dateOfComment'],
              commentId: key,
              comment: value['comment'],
              uid: value['uid']));
        });
      }
      listOfCommentsForThisPosts = tempComments;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addCommentToThisPost(String myDp, String myuserName,
      String comment, String myUid, String postId) async {
    final String api = constants().fetchApi + 'comments/${postId}.json';
    DateTime dateTime = DateTime.now();
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    final String dateOfComment = '${day}/${month}/${year}';
    try {
      http
          .post(Uri.parse(api),
              body: json.encode({
                'dateOfComment': dateOfComment,
                'comment': comment,
                'uid': myUid,
                'userDp': myDp,
                'userName': myuserName,
                'commentId': ''
              }))
          .then((value) {
        final newCommentResponseData =
            json.decode(value.body) as Map<String, dynamic>;
        final commentId = newCommentResponseData['name'].toString();
        listOfCommentsForThisPosts.add(CommentModel(
            dateOfComment: dateOfComment,
            commentId: commentId,
            userDp: myDp,
            userName: myuserName,
            comment: comment,
            uid: myUid));
        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
  }

  Future<NexusUser?> fetchAnyUser(String uid) async {
    final String api = constants().fetchApi + 'users/${uid}.json';
    NexusUser? user;
    try {
      final response = await http.get(Uri.parse(api));
      final data = json.decode(response.body) as Map<String, dynamic>;
      user = NexusUser(
          bio: data['bio'],
          coverImage: data['coverImage'],
          dp: data['dp'],
          email: data['email'],
          followers: data['followers'] ?? [],
          followings: data['followings'] ?? [],
          title: data['title'],
          uid: data['uid'],
          username: data['username']);
      return user;
    } catch (error) {
      print(error);
    }
  }
}
