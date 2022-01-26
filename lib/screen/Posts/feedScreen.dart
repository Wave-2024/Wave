import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/General/notificationScreen.dart';
import 'package:nexus/screen/ProfileDetails/userProfile.dart';
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
  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    debugPrint('reached');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> setPosts() async {
     
      await Provider.of<usersProvider>(context, listen: false)
          .setFeedPosts(currentUser!.uid.toString());
      return;
    }

    final Map<String, PostModel> savedPosts =
        Provider.of<usersProvider>(context).fetchSavedPostsMap;
    final List<PostModel> feedPosts =
        Provider.of<usersProvider>(context).fetchFeedPostList;
    print(feedPosts.length);
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
                  height: displayHeight(context) * 0.07,
                  width: displayWidth(context),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 20, right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.50),
                          child: Text(
                            "Nexus",
                            style: TextStyle(
                                color: Colors.orange[600],
                                fontSize: displayWidth(context) * 0.06,
                                fontWeight: FontWeight.bold),
                          ),
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
                                '5',
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
                const Opacity(opacity: 0.0, child: Divider()),
                Container(
                  color: Colors.white,
                  height: displayHeight(context) * 0.865,
                  width: displayWidth(context),
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 21.0, right: 21, top: 10),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return feedPosts.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Looks like you are not following anyone',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : Padding(
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
                      )),
                )
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                radius: displayWidth(context) * 0.06,
                                backgroundImage: NetworkImage(user.dp),
                              )
                            : CircleAvatar(
                                radius: displayWidth(context) * 0.06,
                                backgroundColor: Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.orange[300],
                                  size: displayWidth(context) * 0.065,
                                ),
                              ),
                      ),
                      const VerticalDivider(),
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
                              fontSize: displayWidth(context) * 0.042,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.chat))
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
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600),
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
                  onDoubleTap: () {
                    if (post.likes.contains(myUid)) {
                      Provider.of<usersProvider>(context, listen: false)
                          .dislikePost(myUid, post.uid, post.post_id, 'feed');
                    } else {
                      Provider.of<usersProvider>(context, listen: false)
                          .likePost(myUid, post.uid, post.post_id, 'feed'
                                             );
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: post.image,
                      height: displayHeight(context) * 0.38,
                      width: displayWidth(context) * 0.68,
                      fit: BoxFit.contain,
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

