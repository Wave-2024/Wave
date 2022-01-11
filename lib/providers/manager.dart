import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:intl/intl.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;

class usersProvider extends ChangeNotifier {
  List<PostModel> postsToDisplay = [];

  List<PostModel> thisProfilePosts = [];

  List<PostModel> get fetchThisProfilePosts {
    return [...thisProfilePosts];
  }

  Map<String, NexusUser> mapOfUsers = {};

  List<PostModel> get fetchPostsToDisplay {
    return [...postsToDisplay];
  }

  Future<void> setFeedPosts(String myUid) async {
    //print('reached setFeed Post Function');
    Map<String, NexusUser> tempMap = {};
    List<dynamic> myFollowings = [];
    List<PostModel> tempPosts = [];
    List<PostModel> finalPosts = [];
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
        print(postsResponse.body);
        postsData.forEach((key, value) {
          tempPosts.add(PostModel(
            dateOfPost: value['caption'],
              caption: value['caption'],
              image: value['image'],
              uid: value['uid'],
              post_id: key,
              likes: value['likes'] ?? []));
        });
        for (int run = 0; run < tempPosts.length; ++run) {
          finalPosts.add(PostModel(
            dateOfPost: tempPosts[run].dateOfPost,
              caption: tempPosts[run].caption,
              image: tempPosts[run].image,
              uid: tempPosts[run].uid,
              post_id: tempPosts[run].post_id,
              likes: tempPosts[run].likes));
        }
      }
    }
    postsToDisplay = finalPosts;
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
      );
      followings = myProfile.followings;
      followings.add(personUid);
      await http.patch(Uri.parse(api1),
          body: json.encode({'followings': followings}));
      final response2 = await http.get(Uri.parse(api2));
      final data2 = json.decode(response2.body) as Map<String, dynamic>;
      peopleProfile = NexusUser(
        title: data2['title'],
        coverImage: data2['coverImage'],
        uid: myUid,
        username: data2['username'],
        email: data2['email'],
        bio: data2['bio'],
        dp: data2['dp'],
        followers: data2['followers'] ?? [],
        followings: data2['followings'] ?? [],
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
              'dateOfPost' : dateOfPost,
            }));
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> likeThisPost(String myUid,String userUid, String postUid) async {
    final String api = constants().fetchApi + 'posts/${userUid}/${postUid}.json';
    List<String> likes = [];
    try {
      final response = await http.get(Uri.parse(api));

      final data = json.decode(response.body) as Map<String, dynamic>;
      likes = data['likes'] ?? [];
      likes.add(myUid);
      await http.patch(Uri.parse(api), body: json.encode({'likes': likes}));
    } catch (error) {
      print(error);
    }
  }

  Future<void> disLikeThisPost(String myUid, String userUid, String postUid) async {
    final String api = constants().fetchApi + 'posts/${userUid}/${postUid}.json';
    List<String> likes = [];
    try {
      final response = await http.get(Uri.parse(api));
      final data = json.decode(response.body) as Map<String, dynamic>;
      likes = data['likes'] ?? [];
      likes.remove(myUid);
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
        print('entered this fucking loop');
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

      thisProfilePosts = temp;
      thisProfilePosts.sort((a,b){
        return a.likes.length>b.likes.length ? 1 : 0;
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
