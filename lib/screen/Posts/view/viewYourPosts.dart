import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/General/fullScreenImage.dart';
import 'package:nexus/screen/General/fullScreenVideo.dart';
import 'package:nexus/screen/Posts/CommentScreens/CommentScreenForYouPosts.dart';
import 'package:nexus/screen/Posts/usersWhoLikedScreen.dart';
import 'package:nexus/screen/ProfileDetails/userProfile.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/reportContainer.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class viewYourPostsSceen extends StatefulWidget {
  final String? myUid;
  final int? index;
  final String? yourUid;

  viewYourPostsSceen({this.myUid, this.index, this.yourUid});

  @override
  State<viewYourPostsSceen> createState() => _viewYourPostsSceenState();
}

class _viewYourPostsSceenState extends State<viewYourPostsSceen> {
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
          .setYourPosts(widget.yourUid.toString());
      return;
    }

    List<PostModel> posts = Provider.of<manager>(context).fetchYourPostsList;
    Map<String, PostModel> savedPostsMap =
        Provider.of<manager>(context).fetchSavedPostsMap;
    Map<String, NexusUser> mapOfUsers =
        Provider.of<manager>(context).fetchAllUsers;
    Widget displayTextPost(
      PostModel post,
      String myUid,
    ) {
      NexusUser user = mapOfUsers[post.uid]!;
      DateTime dateTime = post.dateOfPost;
      String day = dateTime.day.toString();
      String year = dateTime.year.toString();
      String month = months[dateTime.month - 1];
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[200],
        ),
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                            if (myUid != user.uid) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => userProfile(
                                      uid: user.uid,
                                    ),
                                  ));
                            }
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
                        (user.followers.length >= 25)
                            ? Icon(
                                Icons.verified,
                                color: Colors.orange[400],
                                size: displayWidth(context) * 0.0485,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text('Hide Post'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: const Text('Hide post'),
                                                actions: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                        child: TextButton(
                                                      child: const Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                        child: TextButton(
                                                      onPressed: () async {
                                                        await Provider.of<
                                                                    manager>(
                                                                context,
                                                                listen: false)
                                                            .hidePost(
                                                                myUid,
                                                                post.uid,
                                                                post.post_id);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Yes',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87)),
                                                    )),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.more_vert))
                  ],
                ),
                Opacity(
                  opacity: 0.0,
                  child: Divider(
                    height: displayHeight(context) * 0.01,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      post.caption,
                      //maxLines: 1,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.034,
                        color: Colors.black87,
                        //fontWeight: FontWeight.w600
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
                                  Provider.of<manager>(context, listen: false)
                                      .dislikePost(myUid, post.uid,
                                          post.post_id, 'self');
                                } else {
                                  Provider.of<manager>(context, listen: false)
                                      .likePost(myUid, post.uid, post.post_id,
                                          'self');
                                }
                              },
                              child: (post.likes.contains(myUid))
                                  ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: displayWidth(context) * 0.04,
                                      child: Center(
                                        child: Image.asset(
                                          'images/like.png',
                                          height:
                                              displayHeight(context) * 0.035,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: displayWidth(context) * 0.04,
                                      child: Center(
                                        child: Image.asset(
                                          'images/like_out.png',
                                          height:
                                              displayHeight(context) * 0.035,
                                        ),
                                      ),
                                    ),
                            ),
                            const Opacity(
                                opacity: 0.0, child: VerticalDivider()),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CommentScreenForYourPosts(
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
                              if (savedPostsMap.containsKey(post.post_id)) {
                                Provider.of<manager>(context, listen: false)
                                    .unsavePost(post.post_id, myUid);
                              } else {
                                Provider.of<manager>(context, listen: false)
                                    .savePost(post, myUid);
                              }
                            },
                            child: Center(
                              child: Center(
                                  child: (savedPostsMap
                                          .containsKey(post.post_id))
                                      ? Image.asset(
                                          'images/bookmark.png',
                                          height:
                                              displayHeight(context) * 0.035,
                                        )
                                      : Image.asset(
                                          'images/bookmark_out.png',
                                          height:
                                              displayHeight(context) * 0.035,
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => usersWhoLikedScreen(
                                    usersWhoLiked: post.likes),
                              ));
                        },
                        child: Text(
                          post.likes.length.toString() + ' likes',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: displayWidth(context) * 0.035,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      (ifPostedToday(post.dateOfPost))
                          ? Text(displayTime(post.dateOfPost),
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: displayWidth(context) * 0.033,
                              ))
                          : Text(
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
      );
    }

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
        title: Text(
          'Posts',
          style: TextStyle(
              color: Colors.black, fontSize: displayWidth(context) * 0.048),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 12.0, left: 16, right: 16, bottom: 12),
            child: ScrollablePositionedList.builder(
              // itemScrollController: itemController,
              itemCount: posts.length,
              initialScrollIndex: widget.index!,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: (posts[index].postType == 'text')
                      ? displayTextPost(posts[index], widget.myUid!)
                      : displayYourPosts(context, posts[index], mapOfUsers,
                      widget.myUid!, months, savedPostsMap),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}



Widget displayYourPosts(
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
    height: displayHeight(context) * 0.725,
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
        height: displayHeight(context) * 0.685,
        width: displayWidth(context) * 0.84,
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
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15))),
                          context: context,
                          builder: (context) {
                            return Container(
                              height: displayHeight(context) * 0.1,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView(
                                    children: [
                                      ListTile(
                                        title: const Text('Report Post'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(15),
                                                      topRight:
                                                      Radius.circular(15))),
                                              context: context,
                                              builder: (BuildContext cx) {
                                                return reportContainer(postId: post.post_id,myUid: myUid,postOwnerId: post.uid);
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert),
                    color: Colors.grey[600],
                  ),
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
                child: Hero(
                  tag: post.post_id,
                  transitionOnUserGestures: true,
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => (post.postType == 'image')
                                  ? fullScreenImage(
                                      image: post.image,
                                      postId: post.post_id,
                                    )
                                  : fullScreenVideo(videoUrl: post.video),
                            ));
                      },
                      onDoubleTap: () {
                        if (post.likes.contains(myUid)) {
                          Provider.of<manager>(context, listen: false)
                              .dislikePost(myUid, post.uid, post.post_id, 'yours');
                        } else {
                          Provider.of<manager>(context, listen: false)
                              .likePost(myUid, post.uid, post.post_id, 'yours');
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: (post.postType == 'image')
                            ? CachedNetworkImage(
                          imageUrl: post.image,
                                height: displayHeight(context) * 0.4,
                                width: displayWidth(context) * 0.8,
                          fit: BoxFit.cover,
                              )
                            : Container(
                                height: displayHeight(context) * 0.4,
                                width: displayWidth(context) * 0.8,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Image.asset(
                                      'images/video_prev.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      ),
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
                                Provider.of<manager>(context, listen: false)
                                    .dislikePost(
                                        myUid, post.uid, post.post_id, 'yours');
                              } else {
                                Provider.of<manager>(context, listen: false)
                                    .likePost(
                                        myUid, post.uid, post.post_id, 'yours');
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
                                    builder: (context) =>
                                        CommentScreenForYourPosts(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => usersWhoLikedScreen(
                                usersWhoLiked: post.likes,
                              ),
                            ));
                      },
                      child: Text(
                        post.likes.length.toString() + ' likes',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: displayWidth(context) * 0.035,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    (ifPostedToday(post.dateOfPost))
                        ? Text(displayTime(post.dateOfPost),
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: displayWidth(context) * 0.033,
                            ))
                        : Text(
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
