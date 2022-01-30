import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nexus/models/NotificationModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/StoryModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/General/notificationScreen.dart';
import 'package:nexus/screen/Story/uploadStory.dart';
import 'package:nexus/screen/ProfileDetails/userProfile.dart';
import 'package:nexus/screen/Story/viewStory.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'CommentScreens/CommentsScreen.dart';

class feedScreen extends StatefulWidget {
  @override
  State<feedScreen> createState() => _feedScreenState();
}

class _feedScreenState extends State<feedScreen> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  User? currentUser;
  bool? init;
  bool? loadScreen;
  File? story;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final picker = ImagePicker();
  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    init = true;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (init!) {
      await Provider.of<usersProvider>(context, listen: false)
          .setNotifications(currentUser!.uid);
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (mounted) {
        setState(() {
          story = File(pickedFile!.path);
        });
      }
    }

    Future<void> setPosts() async {
      await Provider.of<usersProvider>(context, listen: false)
          .setFeedPosts(currentUser!.uid.toString());
      return;
    }

    final bool myStory =
        Provider.of<usersProvider>(context).hasStory(currentUser!.uid);
    final List<StoryModel> stories =
        Provider.of<usersProvider>(context).fetchStoryList;
    final List<NotificationModel> notificationList =
        Provider.of<usersProvider>(context).fetchNotifications;
    final List<NotificationModel> unreadNotificationList =
        notificationList.where((element) => !element.read!).toList();
    final Map<String, PostModel> savedPosts =
        Provider.of<usersProvider>(context).fetchSavedPostsMap;
    final List<PostModel> feedPosts =
        Provider.of<usersProvider>(context).fetchFeedPostList;
    final Map<String, NexusUser> allUsers =
        Provider.of<usersProvider>(context).fetchAllUsers;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.white,
          child: LiquidPullToRefresh(
            color: Colors.orange[400],
            animSpeedFactor: 5,
            height: displayHeight(context) * 0.2,
            key: _refreshIndicatorKey,
            showChildOpacityTransition: false,
            onRefresh: setPosts,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: displayHeight(context) * 0.08,
                  width: displayWidth(context),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 20, right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                'Wave',
                                style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w400,
                                    fontSize: displayWidth(context) * 0.07),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ));
                          },
                          child: Badge(
                              badgeColor: Colors.red[400]!,
                              badgeContent: Text(
                                unreadNotificationList.length.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: displayWidth(context) * 0.03),
                              ),
                              child: const Icon(Icons.notifications_none)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: displayHeight(context) * 0.88,
                  width: displayWidth(context),
                  //color: Colors.yellow,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: displayHeight(context) * 0.15,
                          width: displayWidth(context),
                          //color: Colors.blue,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (myStory)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        viewStory(
                                                      myUid: currentUser!.uid,
                                                      story: StoryModel(
                                                          uid: currentUser!.uid,
                                                          story: allUsers[
                                                                  currentUser!
                                                                      .uid]!
                                                              .story,
                                                          storyTime: allUsers[
                                                                  currentUser!
                                                                      .uid]!
                                                              .storyTime,
                                                          views: allUsers[
                                                                  currentUser!
                                                                      .uid]!
                                                              .views),
                                                    ),
                                                  ));
                                            },
                                            child: CircleAvatar(
                                              radius:
                                                  displayWidth(context) * 0.095,
                                              backgroundColor: Colors.orange,
                                              child: CircleAvatar(
                                                radius: displayWidth(context) *
                                                    0.09,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius:
                                                      displayWidth(context) *
                                                          0.08,
                                                  backgroundColor:
                                                      Colors.orange,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          allUsers[currentUser!
                                                                  .uid]!
                                                              .story),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height:
                                                displayHeight(context) * 0.006,
                                          ),
                                          Text(
                                            'My Story',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    displayWidth(context) *
                                                        0.032),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await pickImage();
                                              if (story != null) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          uploadStoryScreen(
                                                        imageFile: story,
                                                      ),
                                                    ));
                                              }
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey[200],
                                              radius:
                                                  displayWidth(context) * 0.07,
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height:
                                                displayHeight(context) * 0.006,
                                          ),
                                          Text(
                                            'Add Story',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    displayWidth(context) *
                                                        0.032),
                                          ),
                                        ],
                                      ),
                                Container(
                                  width: displayWidth(context) * 0.8,
                                  height: displayHeight(context) * 0.15,
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: stories.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        viewStory(
                                                      myUid: currentUser!.uid,
                                                      story: stories[index],
                                                    ),
                                                  ));
                                            },
                                            child: CircleAvatar(
                                              radius:
                                                  displayWidth(context) * 0.095,
                                              backgroundColor: Colors.orange,
                                              child: CircleAvatar(
                                                radius: displayWidth(context) *
                                                    0.09,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius:
                                                      displayWidth(context) *
                                                          0.08,
                                                  backgroundColor:
                                                      Colors.orange,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          stories[index]
                                                              .story!),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height:
                                                displayHeight(context) * 0.006,
                                          ),
                                          Text(
                                            allUsers[stories[index].uid]!
                                                .username,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    displayWidth(context) *
                                                        0.032),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.01,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21.0, right: 21, top: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: displayPostsForFeed(
                                    context,
                                    feedPosts[index],
                                    allUsers,
                                    currentUser!.uid.toString(),
                                    months,
                                    savedPosts),
                              );
                            },
                            itemCount: feedPosts.length,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget displayPostsForFeed(
    BuildContext context,
    PostModel post,
    Map<String, dynamic> mapOfUsers,
    String myUid,
    List<String> months,
    Map<String, PostModel> savedPosts) {
  DateTime dateTime = DateFormat('d/MM/yyyy').parse(post.dateOfPost);
  String day = dateTime.day.toString();
  String year = dateTime.year.toString();
  String month = months[dateTime.month - 1];
  NexusUser user = mapOfUsers[post.uid];
  return Container(
    height: displayHeight(context) * 0.7,
    width: displayWidth(context),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.grey[200],
    ),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        height: displayHeight(context) * 0.66,
        width: displayWidth(context) * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => userProfile(
                              uid: user.uid,
                            ),
                          ));
                    },
                    child: (user.dp != '')
                        ? CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            radius: displayWidth(context) * 0.045,
                            backgroundImage: NetworkImage(user.dp),
                          )
                        : CircleAvatar(
                            radius: displayWidth(context) * 0.045,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              color: Colors.orange[300],
                              size: displayWidth(context) * 0.05,
                            ),
                          ),
                  ),
                  VerticalDivider(
                    width: displayWidth(context) * 0.028,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => userProfile(
                              uid: user.uid,
                            ),
                          ));
                    },
                    child: Text(
                      user.username,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: displayWidth(context) * 0.035,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(
                    width: displayWidth(context) * 0.005,
                  ),
                  (user.followers.length >= 5)
                      ? Icon(
                          Icons.verified,
                          color: Colors.orange[400],
                          size: displayWidth(context) * 0.0485,
                        )
                      : SizedBox(),
                ],
              ),
              Opacity(
                opacity: 0.0,
                child: Divider(
                  height: displayHeight(context) * 0.02,
                ),
              ),
              Center(
                child: Container(
                    height: displayHeight(context) * 0.03,
                    width: displayWidth(context) * 0.68,
                    //color: Colors.redAccent,
                    child: Text(
                      post.caption,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: displayWidth(context) * 0.034,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                    )),
              ),
              Opacity(
                opacity: 0.0,
                child: Divider(
                  height: displayHeight(context) * 0.02,
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Dialog(
                            insetAnimationCurve: Curves.easeInOutQuad,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: post.image,
                                  fit: BoxFit.contain,
                                  height: displayHeight(context) * 0.5,
                                )),
                          ),
                        );
                      },
                    );
                  },
                  onDoubleTap: () {
                    if (post.likes.contains(myUid)) {
                      Provider.of<usersProvider>(context, listen: false)
                          .dislikePost(myUid, post.uid, post.post_id, 'feed');
                    } else {
                      Provider.of<usersProvider>(context, listen: false)
                          .likePost(myUid, post.uid, post.post_id, 'feed');
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: post.image,
                      height: displayHeight(context) * 0.4,
                      width: displayWidth(context) * 0.68,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              //Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                  height: displayHeight(context) * 0.075,
                  width: displayWidth(context) * 0.8,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (post.likes.contains(myUid)) {
                                Provider.of<usersProvider>(context,
                                        listen: false)
                                    .dislikePost(
                                        myUid, post.uid, post.post_id, 'feed');
                              } else {
                                Provider.of<usersProvider>(context,
                                        listen: false)
                                    .likePost(
                                        myUid, post.uid, post.post_id, 'feed');
                              }
                            },
                            child: (post.likes.contains(myUid))
                                ? CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: displayWidth(context) * 0.04,
                                    child: Center(
                                      child: Image.asset(
                                        'images/like.png',
                                        height: displayHeight(context) * 0.035,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: displayWidth(context) * 0.04,
                                    child: Center(
                                      child: Image.asset(
                                        'images/like_out.png',
                                        height: displayHeight(context) * 0.035,
                                      ),
                                    ),
                                  ),
                          ),
                          const Opacity(opacity: 0.0, child: VerticalDivider()),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                      postOwner: user,
                                      postId: post.post_id,
                                    ),
                                  ));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: displayWidth(context) * 0.04,
                              child: Center(
                                child: Image.asset(
                                  'images/comment.png',
                                  height: displayHeight(context) * 0.035,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: displayWidth(context) * 0.04,
                        child: InkWell(
                          onTap: () {
                            if (savedPosts.containsKey(post.post_id)) {
                              Provider.of<usersProvider>(context, listen: false)
                                  .unsavePost(post.post_id, myUid);
                            } else {
                              Provider.of<usersProvider>(context, listen: false)
                                  .savePost(post, myUid);
                            }
                          },
                          child: Center(
                            child: Center(
                                child: (savedPosts.containsKey(post.post_id))
                                    ? Image.asset(
                                        'images/bookmark.png',
                                        height: displayHeight(context) * 0.035,
                                      )
                                    : Image.asset(
                                        'images/bookmark_out.png',
                                        height: displayHeight(context) * 0.035,
                                      )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.likes.length.toString() + ' likes',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: displayWidth(context) * 0.035,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${day} ${month} ${year}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: displayWidth(context) * 0.033,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
