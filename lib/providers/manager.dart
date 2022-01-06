import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;

class usersProvider extends ChangeNotifier {
  List<PostModel> postsToDisplay = [];

  Map<String, NexusUser> mapOfUsers = {};

  List<PostModel> get fetchPostsToDisplay {
    return [...postsToDisplay];
  }

  Future<void> setFeedPosts(String myUid) async {
    print('reached setFeed Post Function');
    Map<String,NexusUser> tempMap = {};
    List<dynamic> myFollowings = [];
    List<dynamic> tempPosts = [];
    List<PostModel> finalPosts = [];
    final String api = constants().fetchApi + 'users/${myUid}.json';
    final response = await http.get(Uri.parse(api));
    final user = json.decode(response.body) as Map<String, dynamic>;

    myFollowings = user['followings'] ?? [];
    for (int index = 0; index < myFollowings.length; ++index) {
      print('reached inside following loop');
      final String api2 =
          constants().fetchApi + 'users/${myFollowings[index].toString()}.json';
      final response2 = await http.get(Uri.parse(api2));
      final userData = json.decode(response2.body) as Map<String, dynamic>;
      NexusUser ne = NexusUser(
          title: userData['title'],
          posts: userData['posts'] ?? [],
          coverImage: userData['coverImage'],
          uid: myFollowings[index].toString(),
          username: userData['username'],
          email: userData['email'],
          bio: userData['bio'],
          dp: userData['dp'],
          followers: userData['followers'] ?? [],
          followings: userData['followings'] ?? []);
      tempMap[myFollowings[index].toString()] = ne;
      tempPosts = userData['posts'] ?? [];
      for (int run = 0; run < tempPosts.length; ++run) {
        finalPosts.add(PostModel(
            caption: tempPosts[run]['caption'],
            image: tempPosts[run]['image'],
            comments: tempPosts[run]['comments'] ?? [],
            uid: tempPosts[run]['uid'],
            post_id: tempPosts[run]['post_id'] ?? '',
            likes: tempPosts[run]['likes'] ?? []));
      }
    }
    postsToDisplay = finalPosts;
    mapOfUsers = tempMap;
    notifyListeners();
  }

  Map<String,dynamic> get fetchMapOfUsers{
    return mapOfUsers;
  }

  List<NexusUser> searchUsers = [];
  NexusUser? currentUser;

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
        posts: data2['posts'] ?? [],
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
        posts: data['posts'] ?? [],
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
        posts: data2['posts'] ?? [],
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
    final String api = constants().fetchApi + 'users/${uid}.json';
    List<dynamic> posts = [];
    try {
      var random = Random();
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
        PostModel post = PostModel(
            caption: caption,
            image: value,
            comments: [],
            uid: uid,
            post_id: '',
            likes: []);
        final response = await http.get(Uri.parse(api));
        final data = json.decode(response.body) as Map<String, dynamic>;
        posts = data['posts'] ?? [];
        posts.add(post.toJson());
        await http.patch(Uri.parse(api), body: json.encode({'posts': posts}));
      });
    } catch (error) {
      print(error);
    }
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
