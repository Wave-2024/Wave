import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Posts/CommentScreens/CommentScreenForSavedPost.dart';

import 'package:nexus/screen/ProfileDetails/userProfile.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class viewMySavedPostScreen extends StatefulWidget {
  final String? myUid;
  final int? index;
  viewMySavedPostScreen({this.index, this.myUid});

  @override
  State<viewMySavedPostScreen> createState() => _viewMySavedPostScreenState();
}

class _viewMySavedPostScreenState extends State<viewMySavedPostScreen> {
  bool isRefreshing = false;
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
  Widget build(BuildContext context) {
    Future<void> setPosts() async {
      await Provider.of<manager>(context, listen: false)
          .setSavedPostsOnce(widget.myUid.toString());
      return;
    }

    Map<String, PostModel> mySavedPostList =
        Provider.of<manager>(context).fetchSavedPostsMap;
    Map<String, PostModel> savedPostsMap =
        Provider.of<manager>(context).fetchSavedPostsMap;
    Map<String, NexusUser> mapOfUsers =
        Provider.of<manager>(context).fetchAllUsers;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            isRefreshing = true;
          });
          await setPosts();
          setState(() {
            isRefreshing = false;
          });
        },
        backgroundColor: Colors.white,
        elevation: 10,
        child: (isRefreshing)
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: load(context),
              )
            : const Icon(
                Icons.refresh,
                color: Colors.orange,
              ),
      ),
      appBar: AppBar(
        title: const Text(
          'My Posts',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: Padding(
            padding: const EdgeInsets.only(
                top: 12.0, left: 21, right: 21, bottom: 12),
            child: ScrollablePositionedList.builder(
              itemCount: savedPostsMap.length,
              initialScrollIndex: widget.index!,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: displayMySavedPosts(
                      context,
                      mySavedPostList.values.toList()[index],
                      mapOfUsers,
                      widget.myUid!,
                      months,
                      savedPostsMap),
                );
              },
            )),
      ),
    );
  }
}

Widget displayMySavedPosts(
    BuildContext context,
    PostModel post,
    Map<String, dynamic> mapOfUsers,
    String myUid,
    List<String> months,
    Map<String, PostModel> savedPosts) {
  DateTime dateTime = post.dateOfPost;
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
                      maxLines: 1,
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
                      Provider.of<manager>(context, listen: false)
                          .dislikePost(myUid, post.uid, post.post_id, 'saved');
                    } else {
                      Provider.of<manager>(context, listen: false)
                          .likePost(myUid, post.uid, post.post_id, 'saved');
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommentScreenForSavedPosts(
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
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: displayWidth(context) * 0.04,
                        child: InkWell(
                          onTap: () {
                            if (savedPosts.containsKey(post.post_id)) {
                              Provider.of<manager>(context, listen: false)
                                  .unsavePost(post.post_id, myUid);
                            } else {
                              Provider.of<manager>(context, listen: false)
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
