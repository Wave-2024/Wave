import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/NotificationModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/StoryModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:nexus/utils/widgets.dart';

class manager extends ChangeNotifier {
  List<NotificationModel> notificationList = [];

  List<StoryModel> feedStoryList = [];

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
    myPostsList.sort((a, b) => b.dateOfPost.compareTo(a.dateOfPost));
    return [...myPostsList];
  }

  List<PostModel> get fetchYourPostsList {
    yourPostsList.sort((a, b) => b.dateOfPost.compareTo(a.dateOfPost));
    return [...yourPostsList];
  }

  List<StoryModel> get fetchStoryList {
    return [...feedStoryList];
  }

  List<PostModel> get fetchFeedPostList {
    return [...feedPostList];
  }

  Map<String, NexusUser> allUsers = {};

  Map<String, NexusUser> get fetchAllUsers {
    return allUsers;
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

  //**********    User details methods    *********//

  Future<void> setAllUsers() async {
    final String api = constants().fetchApi + 'users.json';
    Map<String, NexusUser> temp = {};
    try {
      final userResponse = await http.get(Uri.parse(api));
      final userData = json.decode(userResponse.body) as Map<String, dynamic>;
      userData.forEach((key, value) {
        temp[key] = NexusUser(
            accountType: value['accountType'] ?? '',
            linkInBio: value['linkInBio'] ?? '',
            blocked: value['blocked'] ?? [],
            views: value['views'] ?? [],
            story: value['story'] ?? '',
            storyTime: DateTime.parse(value['storyTime']),
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
    } catch (error) {}
  }

  //**********    User details update methods    *********//

  Future<void> addCoverPicture(File? newImage, String uid) async {
    String imageLocation = 'users/${uid}/details/cp';
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
          allUsers[uid]!.changeCoverPicture(value);
          notifyListeners();
        });
      } catch (error) {}
    });
  }

  Future<void> addProfilePicture(File? newImage, String uid) async {
    String imageLocation = 'users/${uid}/details/dp';
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(imageLocation);
    final UploadTask uploadTask = storageReference.putFile(newImage!);
    final TaskSnapshot taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL().then((downloadLink) async {
      final String api = constants().fetchApi + 'users/${uid}.json';
      try {
        await http
            .patch(Uri.parse(api), body: jsonEncode({'dp': downloadLink}))
            .then((value) {
          allUsers[uid]!.changeDP(downloadLink);
          notifyListeners();
        });
      } catch (error) {}
    });
  }

  Future<void> editMyProfile(String uid, String fullName, String userName,
      String bio, String accountType, String linkInBio) async {
    final String api = constants().fetchApi + 'users/${uid}.json';
    try {
      http
          .patch(Uri.parse(api),
              body: jsonEncode({
                'title': fullName,
                'username': userName,
                'bio': bio,
                'linkInBio': linkInBio,
                'accountType': accountType
              }))
          .then((value) {
        allUsers[uid]!
            .editProfile(userName, fullName, bio, linkInBio, accountType);
        notifyListeners();
      });
    } catch (error) {}
  }

  //**********    Follow / Unfollow methods    *********//

  Future<void> followUser(String myUid, String yourUid) async {
    allUsers[myUid]!.addFollowing(yourUid);
    allUsers[yourUid]!.addFolllower(myUid);
    notifyListeners();
    List myFollowings = await getMyFollowings(myUid);
    myFollowings.add(yourUid);
    List yourFollowers = await getYourFollowers(yourUid);
    yourFollowers.add(myUid);
    final String myApi = constants().fetchApi + 'users/${myUid}.json';
    final String yourApi = constants().fetchApi + 'users/${yourUid}.json';
    await http.patch(Uri.parse(myApi),
        body: json.encode({'followings': myFollowings}));
    await http.patch(Uri.parse(yourApi),
        body: json.encode({'followers': yourFollowers}));
    await sendNotification(myUid, yourUid, '', 'follow');
    String? chatId = generateChatRoomUsingUid(myUid, yourUid);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(myUid)
        .collection('mychats')
        .doc(chatId)
        .set({
      'chatId': chatId,
      'last seen': Timestamp.now(),
      'uid': yourUid,
    });
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(yourUid)
        .collection('mychats')
        .doc(chatId)
        .set({
      'chatId': chatId,
      'last seen': Timestamp.now(),
      'uid': myUid,
    });
    await setFeedPosts(myUid);
  }

  Future<List<dynamic>> getYourFollowers(String uid) async {
    final String api = constants().fetchApi + 'users/${uid}.json';
    List<dynamic>? followers;
    final response = await http.get(Uri.parse(api));
    final data = json.decode(response.body) as Map<String, dynamic>;
    followers = data['followers'] ?? [];
    return followers!;
  }

  Future<List<dynamic>> getMyFollowings(String uid) async {
    final String api = constants().fetchApi + 'users/${uid}.json';
    List<dynamic>? followings;
    final response = await http.get(Uri.parse(api));
    final data = json.decode(response.body) as Map<String, dynamic>;
    followings = data['followings'] ?? [];
    return followings!;
  }

  Future<void> unFollowUser(String myUid, String yourUid) async {
    allUsers[myUid]!.removeFollowing(yourUid);
    allUsers[yourUid]!.removeFollower(myUid);
    notifyListeners();
    List myFollowings = await getMyFollowings(myUid);
    myFollowings.remove(yourUid);
    List yourFollowers = await getYourFollowers(yourUid);
    yourFollowers.remove(myUid);
    final String myApi = constants().fetchApi + 'users/${myUid}.json';
    final String yourApi = constants().fetchApi + 'users/${yourUid}.json';
    await http.patch(Uri.parse(myApi),
        body: json.encode({'followings': myFollowings}));
    await http.patch(Uri.parse(yourApi),
        body: json.encode({'followers': yourFollowers}));
    await setFeedPosts(myUid);
  }

  //**********    Setting posts -> Feed posts , My posts , Your posts   *********//

  Future<void> setFeedPosts(String myUid) async {
    List<PostModel> tempPostList = [];
    List<StoryModel> tempStoryList = [];
    Map<String, dynamic> data = {};
    final String api = constants().fetchApi + 'posts.json';
    final res = await http.get(Uri.parse(api));
    if (json.decode(res.body) != null) {
      data = json.decode(res.body) as Map<String, dynamic>;
    }
    List<dynamic> myFollowing = allUsers[myUid]!.followings;

    if (data.containsKey(myUid)) {
      // Trying to set my posts
      final MyPostMap = data[myUid] as Map<String, dynamic>;
      for (String postId in MyPostMap.keys.toList()) {
        final postMap = MyPostMap[postId] as Map<String, dynamic>;
        PostModel p = PostModel(
            postType: postMap['postType'],
            video: postMap['video'],
            hiddenFrom: postMap['hiddenFrom'] ?? [],
            caption: postMap['caption'],
            dateOfPost: DateTime.parse(postMap['dateOfPost']),
            image: postMap['image'],
            uid: postMap['uid'],
            post_id: postId,
            likes: postMap['likes'] ?? []);
        myPostsMap[postId] = p;
        myPostsList.add(p);
      }
    }
    for (String uid in myFollowing) {
      if (hasStory(uid)) {
        tempStoryList.add(StoryModel(
            story: allUsers[uid]!.story,
            storyTime: allUsers[uid]!.storyTime,
            views: allUsers[uid]!.views,
            uid: uid));
      }
      if (data.containsKey(uid)) {
        final headPostMap = data[uid] as Map<String, dynamic>;
        for (String postId in headPostMap.keys.toList()) {
          final postMap = headPostMap[postId] as Map<String, dynamic>;
          PostModel p = PostModel(
              postType: postMap['postType'],
              video: postMap['video'],
              hiddenFrom: postMap['hiddenFrom'] ?? [],
              caption: postMap['caption'],
              dateOfPost: DateTime.parse(postMap['dateOfPost']),
              image: postMap['image'],
              uid: postMap['uid'],
              post_id: postId,
              likes: postMap['likes'] ?? []);
          if (timeBetweenInDays(p.dateOfPost, DateTime.now()) <= 6 &&
              !(p.hiddenFrom.contains(myUid))) {
            feedPostMap[postId] = p;
            tempPostList.add(p);
          }
        }
      }
    }
    feedPostList = tempPostList;
    feedPostList = tempPostList;
    feedStoryList.sort((a, b) => b.storyTime!.compareTo(a.storyTime!));
    feedPostList.sort((a, b) => b.dateOfPost.compareTo(a.dateOfPost));
    notifyListeners();
  }

  Future<void> setMyPosts(String uid) async {
    List<PostModel> tempList = [];
    Map<String, PostModel> tempMap = {};
    final String api = constants().fetchApi + 'posts/${uid}.json';
    final postResponse = await http.get(Uri.parse(api));
    if (json.decode(postResponse.body) != null) {
      final postData = json.decode(postResponse.body) as Map<String, dynamic>;
      postData.forEach((key, value) {
        PostModel p = PostModel(
            postType: value['postType'],
            video: value['video'],
            hiddenFrom: value['hiddenFrom'] ?? [],
            caption: value['caption'],
            dateOfPost: DateTime.parse(value['dateOfPost']),
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

  Future<void> setYourPosts(String uid) async {
    List<PostModel> tempList = [];
    Map<String, PostModel> tempMap = {};
    final String api = constants().fetchApi + 'posts/${uid}.json';
    final postResponse = await http.get(Uri.parse(api));
    if (json.decode(postResponse.body) != null) {
      final postData = json.decode(postResponse.body) as Map<String, dynamic>;
      postData.forEach((key, value) {
        PostModel p = PostModel(
            postType: value['postType'],
            video: value['video'],
            hiddenFrom: value['hiddenFrom'] ?? [],
            caption: value['caption'],
            dateOfPost: DateTime.parse(value['dateOfPost']),
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

  Future<void> newTextPost(String caption, String uid) async {
    final String api = constants().fetchApi + 'posts/${uid}.json';
    try {
      DateTime datetime = DateTime.now();
      final String dateOfPost = datetime.toString();
      http
          .post(Uri.parse(api),
              body: json.encode({
                'caption': caption,
                'postType': 'text',
                'video': '',
                'image': '',
                'uid': uid,
                'likes': [],
                'dateOfPost': dateOfPost,
              }))
          .then((v) {
        final postData = json.decode(v.body) as Map<String, dynamic>;
        myPostsMap[postData['name']] = PostModel(
            postType: "text",
            video: '',
            hiddenFrom: [],
            caption: caption,
            dateOfPost: datetime,
            image: '',
            uid: uid,
            post_id: postData['name'],
            likes: []);
        myPostsList.add(PostModel(
            postType: 'text',
            video: '',
            hiddenFrom: [],
            caption: caption,
            dateOfPost: datetime,
            image: '',
            uid: uid,
            post_id: postData['name'],
            likes: []));

        notifyListeners();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> newImagePost(String caption, String uid, File image) async {
    final String api = constants().fetchApi + 'posts/${uid}.json';
    try {
      var random = Random();
      DateTime datetime = DateTime.now();
      final String dateOfPost = datetime.toString();
      int random1 = random.nextInt(999999);
      int random2 = random.nextInt(555555);
      int random3 = random.nextInt(101);
      int random4 = random.nextInt(540);
      final String name = '${random1}${random2}${random3}${random4}';
      final String location = '${uid}/posts/image/${name}';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(location);
      final UploadTask uploadTask = storageReference.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then((value) async {
        http
            .post(Uri.parse(api),
                body: json.encode({
                  'caption': caption,
                  'postType': 'image',
                  'video': '',
                  'image': value,
                  'uid': uid,
                  'likes': [],
                  'dateOfPost': dateOfPost,
                }))
            .then((v) {
          final postData = json.decode(v.body) as Map<String, dynamic>;
          myPostsMap[postData['name']] = PostModel(
              postType: "image",
              video: '',
              hiddenFrom: [],
              caption: caption,
              dateOfPost: datetime,
              image: value,
              uid: uid,
              post_id: postData['name'],
              likes: []);
          myPostsList.add(PostModel(
              postType: 'image',
              video: '',
              hiddenFrom: [],
              caption: caption,
              dateOfPost: datetime,
              image: value,
              uid: uid,
              post_id: postData['name'],
              likes: []));

          notifyListeners();
        });
      });
    } catch (error) {}
  }

  Future<void> newVideoPost(String caption, String uid, File video) async {
    final String api = constants().fetchApi + 'posts/${uid}.json';
    try {
      var random = Random();
      DateTime datetime = DateTime.now();
      final String dateOfPost = datetime.toString();
      int random1 = random.nextInt(999999);
      int random2 = random.nextInt(555555);
      int random3 = random.nextInt(101);
      int random4 = random.nextInt(540);
      final String name = '${random1}${random2}${random3}${random4}';
      final String location = '${uid}/posts/video/${name}';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(location);
      final UploadTask uploadTask = storageReference.putFile(video);
      final TaskSnapshot taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then((value) async {
        http
            .post(Uri.parse(api),
                body: json.encode({
                  'caption': caption,
                  'postType': 'video',
                  'video': value,
                  'image': '',
                  'uid': uid,
                  'likes': [],
                  'dateOfPost': dateOfPost,
                }))
            .then((v) {
          final postData = json.decode(v.body) as Map<String, dynamic>;
          myPostsMap[postData['name']] = PostModel(
              postType: "video",
              video: value,
              hiddenFrom: [],
              caption: caption,
              dateOfPost: datetime,
              image: '',
              uid: uid,
              post_id: postData['name'],
              likes: []);
          myPostsList.add(PostModel(
              postType: 'video',
              video: value,
              hiddenFrom: [],
              caption: caption,
              dateOfPost: datetime,
              image: '',
              uid: uid,
              post_id: postData['name'],
              likes: []));

          notifyListeners();
        });
      });
    } catch (error) {}
  }

  Future<void> deletePost(String myUid, String postId) async {
    final String api = constants().fetchApi + 'posts/${myUid}/$postId.json';
    try {
      myPostsMap.remove(postId);
      myPostsList.removeWhere((element) => element.post_id == postId);
      notifyListeners();
      await http.delete(Uri.parse(api));
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (error) {}
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
              postType: oldPost.postType,
              video: oldPost.video,
              hiddenFrom: oldPost.hiddenFrom,
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          feedPostList.insert(
              index,
              PostModel(
                  postType: oldPost.postType,
                  video: oldPost.video,
                  hiddenFrom: oldPost.hiddenFrom,
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
              postType: oldPost.postType,
              video: oldPost.video,
              hiddenFrom: oldPost.hiddenFrom,
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          myPostsList.insert(
              index,
              PostModel(
                  postType: oldPost.postType,
                  video: oldPost.video,
                  hiddenFrom: oldPost.hiddenFrom,
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
              postType: oldPost.postType,
              video: oldPost.video,
              hiddenFrom: oldPost.hiddenFrom,
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          yourPostsList.insert(
              index,
              PostModel(
                  postType: oldPost.postType,
                  video: oldPost.video,
                  hiddenFrom: oldPost.hiddenFrom,
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
        {}
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
              postType: oldPost.postType,
              video: oldPost.video,
              hiddenFrom: oldPost.hiddenFrom,
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);

          feedPostList.insert(
              index,
              PostModel(
                  postType: oldPost.postType,
                  video: oldPost.video,
                  caption: oldPost.caption,
                  hiddenFrom: oldPost.hiddenFrom,
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
              postType: oldPost.postType,
              video: oldPost.video,
              hiddenFrom: oldPost.hiddenFrom,
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          myPostsList.insert(
              index,
              PostModel(
                  postType: oldPost.postType,
                  video: oldPost.video,
                  caption: oldPost.caption,
                  dateOfPost: oldPost.dateOfPost,
                  image: oldPost.image,
                  uid: oldPost.uid,
                  post_id: oldPost.post_id,
                  hiddenFrom: oldPost.hiddenFrom,
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
              postType: oldPost.postType,
              video: oldPost.video,
              hiddenFrom: oldPost.hiddenFrom,
              caption: oldPost.caption,
              dateOfPost: oldPost.dateOfPost,
              image: oldPost.image,
              uid: oldPost.uid,
              post_id: oldPost.post_id,
              likes: likes);
          yourPostsList.insert(
              index,
              PostModel(
                  postType: oldPost.postType,
                  video: oldPost.video,
                  caption: oldPost.caption,
                  hiddenFrom: oldPost.hiddenFrom,
                  dateOfPost: oldPost.dateOfPost,
                  image: oldPost.image,
                  uid: oldPost.uid,
                  post_id: oldPost.post_id,
                  likes: likes));
          notifyListeners();
        }
        break;
      default:
        {}
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
    } catch (error) {}
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
          postType: oldPost.postType,
          video: oldPost.video,
          hiddenFrom: oldPost.hiddenFrom,
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
    } catch (error) {}
  }

  Future<PostModel> getThisPostDetail(String op, String postId) async {
    PostModel? returnThisPost;
    final String api = constants().fetchApi + 'posts/${op}/${postId}.json';
    try {
      final response = await http.get(Uri.parse(api));
      final data = json.decode(response.body) as Map<String, dynamic>;
      returnThisPost = PostModel(
          video: data['video'],
          postType: data['postType'],
          hiddenFrom: data['hiddenFrom'] ?? [],
          caption: data['caption'],
          dateOfPost: DateTime.parse(data['dateOfPost']),
          image: data['image'],
          uid: data['uid'],
          post_id: postId,
          likes: data[postId] ?? []);
      return returnThisPost;
    } catch (error) {}
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
    } catch (error) {}
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
    if (myUid == yourId) {
      return;
    }
    final String api = constants().fetchApi + 'notifications/${yourId}.json';
    try {
      await http.post(Uri.parse(api),
          body: json.encode({
            'notifierUid': myUid,
            'type': type,
            'time': DateTime.now().toString(),
            'postId': postId,
            'read': false
          }));
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> commentOnPost(
      String myId, String yourId, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'comment': comment,
      'time': Timestamp.now(),
      'uid': myId,
      'replies': [],
      'likes': []
    }).then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(value.id)
          .update({'commentId': value.id});
    });
    await sendNotification(myId, yourId, postId, 'comment');
  }

  bool isMyPost(String postId) {
    return myPostsMap.containsKey(postId);
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

  Future<void> readAllNotificationAtOnce(String myUid) async {
    final String preApi = constants().fetchApi + 'notifications/${myUid}/';
    try {
      for (var notification in notificationList) {
        notification.updateNotificationStatus();
      }
      notifyListeners();
      for (var notification in notificationList) {
        final String api = preApi + '${notification.notificationId}.json';
        await http.patch(Uri.parse(api), body: json.encode({'read': true}));
      }
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
    await http.patch(Uri.parse(api),
        body: json.encode({
          'read': true,
        }));
  }

  List<NotificationModel> get fetchNotifications {
    notificationList.sort((a, b) => b.time!.compareTo(a.time!));
    return [...notificationList];
  }

  Future<void> addStoryToServer(String myUid, File? story) async {
    final String imageLocation = '${myUid}/story/storyImage';
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(imageLocation);
    final UploadTask uploadTask = storageReference.putFile(story!);
    final TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) async {
      final String api = constants().fetchApi + 'users/${myUid}.json';
      await http.patch(Uri.parse(api),
          body: json.encode({
            'story': value,
            'storyTime': DateTime.now().toString(),
            'views': [],
          }));
      allUsers[myUid]!.addStory(value);
      notifyListeners();
    });
  }

  bool hasStory(String uid) {
    if (allUsers[uid]!.story != '' &&
        timeBetween(allUsers[uid]!.storyTime, DateTime.now()) < 24) return true;
    return false;
  }

  Future<void> deleteStoryFromServer(String myUid) async {
    final String api = constants().fetchApi + 'users/${myUid}.json';
    allUsers[myUid]!.removeStroy();
    notifyListeners();
    try {
      await http.patch(Uri.parse(api),
          body: json.encode({
            'story': '',
            'views': [],
          }));
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> increaseViewsOnStory(String uid, String myUid) async {
    final String api = constants().fetchApi + 'users/${uid}.json';
    List<dynamic> tempViews;
    try {
      final res = await http.get(Uri.parse(api));
      final data = json.decode(res.body) as Map<String, dynamic>;
      tempViews = data['views'] ?? [];
      if (myUid != uid && !tempViews.contains(myUid)) {
        tempViews.add(myUid);
        await http.patch(Uri.parse(api),
            body: json.encode({'views': tempViews}));
      }
    } catch (error) {}
  }

  // *****  Post reporting functions  **** ////

  Future<void> reportPost(
      String myUid, String report, String postOwnerId, String postId) async {
    if (!feedPostMap[postId]!.hiddenFrom.contains(myUid)) {
      feedPostMap[postId]!.hideThisPostForMe(myUid);
      int index =
          feedPostList.indexWhere((element) => element.post_id == postId);
      feedPostList.removeAt(index);
      await reportThisPost(postOwnerId, postId, report);
      final String api =
          constants().fetchApi + 'posts/${postOwnerId}/${postId}.json';
      List<dynamic> currentListOfHiddenUsers =
          await fetchListOfUsersWhoHideThisPost(postOwnerId, postId);
      currentListOfHiddenUsers.add(myUid);
      await http.patch(Uri.parse(api),
          body: json.encode({'hiddenFrom': currentListOfHiddenUsers}));
      notifyListeners();
    }
  }

  Future<List<dynamic>> fetchListOfUsersWhoHideThisPost(
      String postOwnerId, String postId) async {
    List<dynamic> users = [];
    final String api =
        constants().fetchApi + 'posts/${postOwnerId}/${postId}.json';
    final response = await http.get(Uri.parse(api));
    if (json.decode(response.body) != null) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      users = data['hiddenFrom'] ?? [];
      return users;
    }
    return users;
  }

  Future<void> hidePost(String myUid, String postOwnerId, String postId) async {
    if (!feedPostMap[postId]!.hiddenFrom.contains(myUid)) {
      feedPostMap[postId]!.hideThisPostForMe(myUid);
      int index =
          feedPostList.indexWhere((element) => element.post_id == postId);
      feedPostList.removeAt(index);
      final String api =
          constants().fetchApi + 'posts/${postOwnerId}/${postId}.json';
      List<dynamic> currentListOfHiddenUsers =
          await fetchListOfUsersWhoHideThisPost(postOwnerId, postId);
      currentListOfHiddenUsers.add(myUid);
      await http.patch(Uri.parse(api),
          body: json.encode({'hiddenFrom': currentListOfHiddenUsers}));
      notifyListeners();
    }
  }

  // ****** Blocking / Unblocking methods ***** //

  Future<void> block(String myUid, String yourUid) async {
    allUsers[myUid]!.blockThisUser(yourUid);
    final String api = constants().fetchApi + 'users/${myUid}.json';
    await http.patch(Uri.parse(api),
        body: json.encode({
          'blocked': allUsers[myUid]!.blocked,
        }));
    await unFollowUser(myUid, yourUid);
    notifyListeners();
  }

  Future<void> unBlock(String myUid, String yourUid) async {
    allUsers[myUid]!.unblockThisUser(yourUid);
    final String api = constants().fetchApi + 'users/${myUid}.json';
    await http.patch(Uri.parse(api),
        body: json.encode({'blocked': allUsers[myUid]!.blocked}));
    notifyListeners();
  }

  Future<void> updateMyProfile(String myUid) async {
    final String api = constants().fetchApi + 'users/${myUid}.json';
    try {
      final response = await http.get(Uri.parse(api));
      final data = json.decode(response.body) as Map<String, dynamic>;
      NexusUser user = NexusUser(
          linkInBio: data['linkInBio'],
          accountType: data['accountType'],
          bio: data['bio'],
          coverImage: data['coverImage'],
          dp: data['dp'],
          blocked: data['blocked'] ?? [],
          email: data['email'],
          followers: data['followers'] ?? [],
          followings: data['followings'] ?? [],
          title: data['title'],
          uid: myUid,
          username: data['username'],
          story: data['story'],
          storyTime: DateTime.parse(data['storyTime']),
          views: data['views'] ?? []);
      allUsers[myUid] = user;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
