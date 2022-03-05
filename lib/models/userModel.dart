import 'dart:convert';

String userToJson(NexusUser data) => json.encode(data.toJson());

class NexusUser {
  NexusUser({
    required this.linkInBio,
    required this.accountType,
    required this.bio,
    required this.coverImage,
    required this.dp,
    required this.blocked,
    required this.email,
    required this.followers,
    required this.followings,
    required this.title,
    required this.uid,
    required this.username,
    required this.story,
    required this.storyTime,
    required this.views,
  });

  String bio; // Bio of the user typically an introduction of the user
  String coverImage; // An image link of the cover image of user
  String dp; // An image link for the dp of user
  String accountType; // Describing the type of account ['Meme','Sports','News','Music','Dance','Social','Business','Celebrity','Gaming']
  String email; // Email id of the user
  List<dynamic> followers; // List of uid of the users who follow this current user
  List<dynamic> followings; // List of uid of the users who this current user follow
  String title; // Title of the user
  String uid; // uid of the user
  String username; // username of the user ( unique )
  String story; // image link for the story
  DateTime storyTime; // Time of story
  String linkInBio; // link in bio to navigate to any website using this link
  List<dynamic> views; // list of users who viewed the stories
  List<dynamic> blocked; // list of blocked user's uid



  Map<String, dynamic> toJson() => {
        "bio": bio,
        "coverImage": coverImage,
        "dp": dp,
        "email": email,
        "followers": List<dynamic>.from(followers.map((x) => x)),
        "followings": List<dynamic>.from(followings.map((x) => x)),
        "title": title,
        "uid": uid,
        "username": username,
        'views': [],
      };


  addStory(String storyImage) {
    story = storyImage;
    storyTime = DateTime.now();
    views = [];
  }

  changeDP(String newDp) {
    dp = newDp;
  }

  changeCoverPicture(String newCp) {
    coverImage = newCp;
  }

  removeStroy() {
    story = '';
    views = [];
  }

  addFollowing(String newUid) {
    followings.add(newUid);
  }

  addFolllower(String newUid) {
    followers.add(newUid);
  }

  removeFollowing(String existingUser) {
    followings.remove(existingUser);
  }

  removeFollower(String existingUser) {
    followers.remove(existingUser);
  }

  blockThisUser(String uid){
    blocked.add(uid);
  }

  unblockThisUser(String uid){
    blocked.remove(uid);
  }

  editProfile(String newUsername, String newTitle, String newBio,String newLinkInBio,String newAccountType) {
    username = newUsername;
    title = newTitle;
    bio = newBio;
    linkInBio = newLinkInBio;
    accountType = newAccountType;
  }
}
