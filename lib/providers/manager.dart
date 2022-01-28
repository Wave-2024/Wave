import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus/models/NotificationModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;

class usersProvider extends ChangeNotifier {
  List<NotificationModel> notificationList = [];

  Map<String, PostModel> feedPostMap = {};

  Map<String, PostModel> yourPostsMap = {};

  Map<String, PostModel> myPostsMap = {};

  Map<String, PostModel> savedPostsMap = {};

  Map<String, PostModel> get fetchSavedPostsMap => savedPostsMap;

  Map<String, PostModel> get fetchFeedPostsMap => feedPostMap;

  Map<String, PostModel> get fetchYourPostsMap => yourPostsMap;

  Map<String, PostModel> get fetchMyPostsMap => myPostsMap;

  List<PostModel> feedPostList = [];

  List<PostModel> yourPostsList = [];

  List<PostModel> myPostsList = [];

  List<PostModel> savedPostList = [];

  List<PostModel> get fetchSavedPostList {
    return [...savedPostList];
  }

  List<PostModel> get fetchMyPostsList {
    myPostsList.sort((a, b) => DateFormat('d/MM/yyyy')
        .parse(b.dateOfPost)
        .compareTo(DateFormat('d/MM/yyyy').parse(a.dateOfPost)));
    return [...myPostsList];
  }

  List<PostModel> get fetchYourPostsList {
    yourPostsList.sort((a, b) => DateFormat('d/MM/yyyy')
        .parse(b.dateOfPost)
        .compareTo(DateFormat('d/MM/yyyy').parse(a.dateOfPost)));
    return [...yourPostsList];
  }

  List<PostModel> get fetchFeedPostList {
    return [...feedPostList];
  }

  Map<String, NexusUser> allUsers = {};

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

  // Function to set posts that will be diplayed on your feed screen
  Future<void> setFeedPosts(String myUid) async {
    List<PostModel> temp = [];
    List<dynamic> myFollowing = allUsers[myUid]!.followings;
    for (int i = 0; i < myFollowing.length; ++i) {
      String uid = myFollowing[i].toString();
      temp.addAll(await getListOfPostsUsingUid(uid));
    }
    feedPostList = temp;
    feedPostList.sort((a, b) => DateFormat('d/MM/yyyy')
        .parse(b.dateOfPost)
        .compareTo(DateFormat('d/MM/yyyy').parse(a.dateOfPost)));
    notifyListeners();
  }

  // Funtion that returns a future list of posts using a provided uid -> only used by setFeedPost()
  Future<List<PostModel>> getListOfPostsUsingUid(String uid) async {
    List<PostModel> list = [];
    final String apiForPosts = constants().fetchApi + 'posts/${uid}.json';
    final responseOfPosts = await http.get(Uri.parse(apiForPosts));
    if (json.decode(responseOfPosts.body) != null) {
      final postData =
          json.decode(responseOfPosts.body) as Map<String, dynamic>;
      postData.forEach((key, value) {
        PostModel p = PostModel(
            caption: value['caption'],
            dateOfPost: value['dateOfPost'],
            image: value['image'],
            uid: value['uid'],
            post_id: key,
            likes: value['likes'] ?? []);
        feedPostMap[key] = p;
        list.add(p);
      });
    }
    return list;
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

  Future<void> followUser(String myUid, String yourUid) async {
    List<dynamic> myFollowings = allUsers[myUid]!.followings;
    myFollowings.add(yourUid);
    List<dynamic> yourFollowers = allUsers[yourUid]!.followers;
    yourFollowers.add(myUid);
    NexusUser myOldProfile = allUsers[myUid]!;
    NexusUser yourOldProfile = allUsers[yourUid]!;

    NexusUser myNewProfile = NexusUser(
        bio: myOldProfile.bio,
        coverImage: myOldProfile.coverImage,
        dp: myOldProfile.dp,
        email: myOldProfile.email,
        followers: myOldProfile.followers,
        followings: myFollowings,
        title: myOldProfile.title,
        uid: myOldProfile.uid,
        username: myOldProfile.username);

    NexusUser yourNewProfile = NexusUser(
        bio: yourOldProfile.bio,
        coverImage: yourOldProfile.coverImage,
        dp: yourOldProfile.dp,
        email: yourOldProfile.email,
        followers: yourFollowers,
        followings: yourOldProfile.followings,
        title: yourOldProfile.title,
        uid: yourOldProfile.uid,
        username: yourOldProfile.username);

    allUsers[yourUid] = yourNewProfile;
    allUsers[myUid] = myNewProfile;
    await updateConnectionDetailToServer(
        myUid, myFollowings, yourUid, yourFollowers);
    notifyListeners();
  }

  Future<void> unFollowUser(String myUid, String yourUid) async {
    List<dynamic> myFollowings = allUsers[myUid]!.followings;
    myFollowings.remove(yourUid);
    List<dynamic> yourFollowers = allUsers[yourUid]!.followers;
    yourFollowers.remove(myUid);
    NexusUser myOldProfile = allUsers[myUid]!;
    NexusUser yourOldProfile = allUsers[yourUid]!;

    NexusUser myNewProfile = NexusUser(
        bio: myOldProfile.bio,
        coverImage: myOldProfile.coverImage,
        dp: myOldProfile.dp,
        email: myOldProfile.email,
        followers: myOldProfile.followers,
        followings: myFollowings,
        title: myOldProfile.title,
        uid: myOldProfile.uid,
        username: myOldProfile.username);

    NexusUser yourNewProfile = NexusUser(
        bio: yourOldProfile.bio,
        coverImage: yourOldProfile.coverImage,
        dp: yourOldProfile.dp,
        email: yourOldProfile.email,
        followers: yourFollowers,
        followings: yourOldProfile.followings,
        title: yourOldProfile.title,
        uid: yourOldProfile.uid,
        username: yourOldProfile.username);

    allUsers[yourUid] = yourNewProfile;
    allUsers[myUid] = myNewProfile;
    await updateConnectionDetailToServer(
        myUid, myFollowings, yourUid, yourFollowers);
    notifyListeners();
  }

  Future<void> updateConnectionDetailToServer(
      String myUid,
      List<dynamic> myFollowings,
      String yourUid,
      List<dynamic> yourFollowers) async {
    final String api1 = constants().fetchApi + 'users/${myUid}.json';
    final String api2 = constants().fetchApi + 'users/${yourUid}.json';
    try {
      await http.patch(Uri.parse(api1),
          body: json.encode({'followings': myFollowings}));
      await http.patch(Uri.parse(api2),
          body: json.encode({'followers': yourFollowers}));
    } catch (error) {
      print(error);
    }
  }

  // Function to set my posts
  Future<void> setMyPosts(String uid) async {
    List<PostModel> tempList = [];
    Map<String, PostModel> tempMap = {};
    final String api = constants().fetchApi + 'posts/${uid}.json';
    final postResponse = await http.get(Uri.parse(api));
    if (json.decode(postResponse.body) != null) {
      final postData = json.decode(postResponse.body) as Map<String, dynamic>;
      postData.forEach((key, value) {
        PostModel p = PostModel(
            caption: value['caption'],
            dateOfPost: value['dateOfPost'],
            image: value['image'],
            uid: value['uid'],
            post_id: key,
            likes: value['likes'] ?? []);
        tempList.add(p);
        tempMap[key] = p;
      });
    }
    myPostsList = tempList;
    myPostsMap = tempMap;
    notifyListeners();
  }

  // Function to set your posts
  Future<void> setYourPosts(String uid) async {
    List<PostModel> tempList = [];
    Map<String, PostModel> tempMap = {};
    final String api = constants().fetchApi + 'posts/${uid}.json';
    final postResponse = await http.get(Uri.parse(api));
    if (json.decode(postResponse.body) != null) {
      final postData = json.decode(postResponse.body) as Map<String, dynamic>;
      postData.forEach((key, value) {
        PostModel p = PostModel(
            caption: value['caption'],
            dateOfPost: value['dateOfPost'],
            image: value['image'],
            uid: value['uid'],
            post_id: key,
            likes: value['likes'] ?? []);
        tempList.add(p);
        tempMap[key] = p;
      });
    }
    yourPostsList = tempList;
    yourPostsMap = tempMap;
    notifyListeners();
  }

  // Function to add new post
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
          myPostsMap[postData['name']] = PostModel(
              caption: caption,
              dateOfPost: dateOfPost,
              image: value,
              uid: uid,
              post_id: postData['name'],
              likes: []);
          myPostsList.add(PostModel(
              caption: caption,
              dateOfPost: dateOfPost,
              image: value,
              uid: uid,
              post_id: postData['name'],
              likes: []));

          notifyListeners();
        });
      });
    } catch (error) {
      print(error);
    }
  }

  // Function to delete post
  Future<void> deletePost(String myUid, String postId) async {
    final String api = constants().fetchApi + 'posts/${myUid}/$postId.json';
    try {
      myPostsMap.remove(postId);
      myPostsList.removeWhere((element) => element.post_id == postId);
      notifyListeners();
      await http.delete(Uri.parse(api));
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (error) {
      print(error);
    }
  }

  // Update likes to server
  Future<void> likePostUpdateToServer(
      String op, String postId, List<dynamic> likes) async {
    final String api = constants().fetchApi + 'posts/${op}/${postId}.json';
    await http.patch(Uri.parse(api), body: json.encode({'likes': likes}));
  }

  // Like post
  Future<void> likePost(
      String myUid, String opId, String postId, String source) async {
    // Souce can be -> "feed","self","yours"

    switch (source) {
      case 'feed':
        {
          PostModel oldPost = feedPostMap[postId]!;
          List<dynamic> likes = oldPost.likes;
          likes.add(myUid);
          int index =
              feedPostList.indexWhere((element) => element.post_id == postId);
          feedPostList.removeAt(index);
          feedPostMap[postId] = PostModel(
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          feedPostList.insert(
              index,
              PostModel(
                  caption: oldPost.caption,
                  dateOfPost: oldPost.dateOfPost,
                  image: oldPost.image,
                  uid: oldPost.uid,
                  post_id: oldPost.post_id,
                  likes: likes));
          notifyListeners();
        }
        break;
      case 'self':
        {
          PostModel oldPost = myPostsMap[postId]!;
          List<dynamic> likes = oldPost.likes;
          likes.add(myUid);
          int index =
              myPostsList.indexWhere((element) => element.post_id == postId);
          myPostsList.removeAt(index);
          myPostsMap[postId] = PostModel(
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          myPostsList.insert(
              index,
              PostModel(
                  caption: oldPost.caption,
                  dateOfPost: oldPost.dateOfPost,
                  image: oldPost.image,
                  uid: oldPost.uid,
                  post_id: oldPost.post_id,
                  likes: likes));
          notifyListeners();
        }
        break;

      case 'yours':
        {
          PostModel oldPost = yourPostsMap[postId]!;
          List<dynamic> likes = oldPost.likes;
          likes.add(myUid);
          int index =
              yourPostsList.indexWhere((element) => element.post_id == postId);
          yourPostsList.removeAt(index);
          yourPostsMap[postId] = PostModel(
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          yourPostsList.insert(
              index,
              PostModel(
                  caption: oldPost.caption,
                  dateOfPost: oldPost.dateOfPost,
                  image: oldPost.image,
                  uid: oldPost.uid,
                  post_id: oldPost.post_id,
                  likes: likes));
          notifyListeners();
        }
        break;
      default:
        {
          print('passed wrong choice');
        }
    }

    List<dynamic> likes = [];
    final String api = constants().fetchApi + 'posts/${opId}/${postId}.json';
    final postResponse = await http.get(Uri.parse(api));
    final postData = json.decode(postResponse.body) as Map<String, dynamic>;
    likes = postData['likes'] ?? [];
    likes.add(myUid);
    await likePostUpdateToServer(opId, postId, likes);
    await setFeedPosts(myUid);
    await setMyPosts(myUid);
    await setYourPosts(opId);
    await sendNotification(myUid, opId, postId, 'like');
  }

  // Dislike post
  Future<void> dislikePost(
      String myUid, String opId, String postId, String source) async {
    // Souce can be -> "feed","self","yours","saved"

    switch (source) {
      case 'feed':
        {
          PostModel oldPost = feedPostMap[postId]!;
          List<dynamic> likes = oldPost.likes;
          likes.remove(myUid);
          int index =
              feedPostList.indexWhere((element) => element.post_id == postId);
          feedPostList.removeAt(index);
          feedPostMap[postId] = PostModel(
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);

          feedPostList.insert(
              index,
              PostModel(
                  caption: oldPost.caption,
                  dateOfPost: oldPost.dateOfPost,
                  image: oldPost.image,
                  uid: oldPost.uid,
                  post_id: oldPost.post_id,
                  likes: likes));
          notifyListeners();
        }
        break;
      case 'self':
        {
          PostModel oldPost = myPostsMap[postId]!;
          List<dynamic> likes = oldPost.likes;
          likes.remove(myUid);
          int index =
              myPostsList.indexWhere((element) => element.post_id == postId);
          myPostsList.removeAt(index);
          myPostsMap[postId] = PostModel(
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          myPostsList.insert(
              index,
              PostModel(
                  caption: oldPost.caption,
                  dateOfPost: oldPost.dateOfPost,
                  image: oldPost.image,
                  uid: oldPost.uid,
                  post_id: oldPost.post_id,
                  likes: likes));
          notifyListeners();
        }
        break;
      case 'yours':
        {
          PostModel oldPost = yourPostsMap[postId]!;
          List<dynamic> likes = oldPost.likes;
          likes.remove(myUid);
          int index =
              yourPostsList.indexWhere((element) => element.post_id == postId);
          yourPostsList.removeAt(index);
          yourPostsMap[postId] = PostModel(
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          yourPostsList.insert(
              index,
              PostModel(
                  caption: oldPost.caption,
                  dateOfPost: oldPost.dateOfPost,
                  image: oldPost.image,
                  uid: oldPost.uid,
                  post_id: oldPost.post_id,
                  likes: likes));
          notifyListeners();
        }
        break;
      default:
        {
          print('passed wrong choice');
        }
    }
    List<dynamic> likes = [];
    final String api = constants().fetchApi + 'posts/${opId}/${postId}.json';
    final postResponse = await http.get(Uri.parse(api));
    final postData = json.decode(postResponse.body) as Map<String, dynamic>;
    likes = postData['likes'] ?? [];
    likes.remove(myUid);
    await likePostUpdateToServer(opId, postId, likes);
    await setFeedPosts(myUid);
    await setMyPosts(myUid);
    await setYourPosts(opId);
  }

  Future<void> setSavedPostsOnce(String uid) async {
    final String api = constants().fetchApi + 'saved/${uid}.json';
    Map<String, PostModel> tempPosts = {};
    Map<String, String> tempKeys = {};
    try {
      final savedPostIdResponse = await http.get(Uri.parse(api));
      if (json.decode(savedPostIdResponse.body) != null) {
        final savedPostIdData =
            json.decode(savedPostIdResponse.body) as Map<String, dynamic>;
        savedPostIdData.forEach((key, value) async {
          tempKeys[value['postId']] = value['saveId'];
          tempPosts[value['postId'].toString()] =
              await getThisPostDetail(value['op'], value['postId'].toString());
        });
      }
      savedPostsMap = tempPosts;
      savedPostsKeys = tempKeys;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateCaption(
      String myUid, String postId, String updatedCaption) async {
    final String api = constants().fetchApi + 'posts/${myUid}/${postId}.json';
    try {
      PostModel oldPost = myPostsMap[postId]!;
      int index =
          myPostsList.indexWhere((element) => element.post_id == postId);
      myPostsList.removeAt(index);
      PostModel updatedPost = PostModel(
          caption: updatedCaption,
          dateOfPost: oldPost.dateOfPost,
          image: oldPost.image,
          uid: oldPost.uid,
          post_id: oldPost.post_id,
          likes: oldPost.likes);
      myPostsList.insert(index, updatedPost);
      myPostsMap[postId] = updatedPost;
      notifyListeners();
      await http.patch(Uri.parse(api),
          body: json.encode({'caption': updatedCaption}));
    } catch (error) {
      print(error);
    }
  }

  Future<PostModel> getThisPostDetail(String op, String postId) async {
    PostModel? returnThisPost;
    final String api = constants().fetchApi + 'posts/${op}/${postId}.json';
    try {
      final response = await http.get(Uri.parse(api));
      final data = json.decode(response.body) as Map<String, dynamic>;
      returnThisPost = PostModel(
          caption: data['caption'],
          dateOfPost: data['dateOfPost'],
          image: data['image'],
          uid: data['uid'],
          post_id: postId,
          likes: data[postId] ?? []);
      return returnThisPost;
    } catch (error) {
      print(error);
    }
    return returnThisPost!;
  }

  Future<void> savePost(
    PostModel postModel,
    String myUid,
  ) async {
    String? saveId;
    final String api = constants().fetchApi + 'saved/${myUid}.json';
    try {
      savedPostsMap[postModel.post_id] = postModel;
      notifyListeners();
      await http
          .post(Uri.parse(api),
              body: json.encode({
                'op': postModel.uid,
                'postId': postModel.post_id,
              }))
          .then((value) async {
        final serverData = json.decode(value.body) as Map<String, dynamic>;
        saveId = serverData['name'];
      });
      final String savePostApi =
          constants().fetchApi + 'saved/${myUid}/${saveId!}.json';
      await http.patch(Uri.parse(savePostApi),
          body: json.encode({'saveId': saveId}));
      savedPostsKeys[postModel.post_id] = saveId!;
      notifyListeners();
    } catch (error) {
      if (savedPostsMap.containsKey(postModel.post_id)) {
        savedPostsMap.remove(postModel.post_id);
      }
    }
  }

  Map<String, String> savedPostsKeys = {};

  Future<void> unsavePost(String postId, String myUid) async {
    final String api = constants().fetchApi +
        'saved/${myUid}/${savedPostsKeys[postId].toString()}.json';
    try {
      await http.delete(Uri.parse(api));
      savedPostsMap.remove(postId);
      savedPostsKeys.remove(postId);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> setNotifications(String myUid) async {
    List<NotificationModel> tempList = [];
    final String api = constants().fetchApi + 'notifications/${myUid}.json';
    try {
      final notificationResponse = await http.get(Uri.parse(api));
      if (json.decode(notificationResponse.body) != null) {
        final notificationData =
            json.decode(notificationResponse.body) as Map<String, dynamic>;
        notificationData.forEach((key, value) {
          tempList.add(NotificationModel(
              notificationId: key,
              read: value['read'],
              notifierUid: value['notifierUid'],
              postId: value['postId'],
              time: DateTime.parse(value['time']),
              type: value['type']));

        });
      }
      notificationList = tempList;
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> sendNotification(
      String myUid, String yourId, String postId, String type) async {
    final String api = constants().fetchApi + 'notifications/${yourId}.json';
    try {
      await http.post(Uri.parse(api),
          body: json.encode({
            'notifierUid': myUid,
            'type': type,
            'time': DateTime.now().toString(),
            'postId': postId,
            'read' : false
          }));
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteNotification(String myUid, String notificationId) async {
    final String api =
        constants().fetchApi + 'notifications/${myUid}/${notificationId}.json';
    int index = notificationList
        .indexWhere((element) => element.notificationId == notificationId);
    notificationList.removeAt(index);
    notifyListeners();
    try {
      await http.delete(Uri.parse(api));
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> readNotification(String myUid, String notificationId) async {
    final String api =
        constants().fetchApi + 'notifications/${myUid}/${notificationId}.json';
    int index = notificationList
        .indexWhere((element) => element.notificationId == notificationId);
    notificationList[index].updateNotificationStatus();
    notifyListeners();
    await http.patch(Uri.parse(api),body: json.encode({
      'read' : true,
    }));
  }

  List<NotificationModel> get fetchNotifications {
    notificationList.sort((a, b) => b.time!.compareTo(a.time!));
    return [...notificationList];
  }
}
