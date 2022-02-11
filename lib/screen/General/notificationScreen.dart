import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/NotificationModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Posts/CommentScreens/CommentScreenForMyPosts.dart';
import 'package:nexus/screen/Posts/view/viewMyPostsScreen.dart';
import 'package:nexus/screen/ProfileDetails/userProfile.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool? init;
  User currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    init = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (init!) {
      await Provider.of<manager>(context).setMyPosts(currentUser.uid);
      init = false;
    }
    super.didChangeDependencies();
  }

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
    List<NotificationModel> list =
        Provider.of<manager>(context).fetchNotifications;
    Map<String, NexusUser> allUsers =
        Provider.of<manager>(context).fetchAllUsers;
    List<PostModel> myPosts = Provider.of<manager>(context).fetchMyPostsList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16.0, bottom: 16, left: 8, right: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Provider.of<manager>(context, listen: false)
                          .readAllNotificationAtOnce(currentUser.uid);
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        height: displayHeight(context) * 0.04,
                        width: displayWidth(context) * 0.6,
                        child: const Center(
                            child: Text(
                          'Mark all as read',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                    ),
                  ),
                  const Opacity(opacity: 0.0, child: Divider()),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Container? tile;
                      int? postIndex;
                      NexusUser user = allUsers[list[index].notifierUid]!;
                      DateTime dateTime = list[index].time!;
                      String day = dateTime.day.toString();
                      String year = dateTime.year.toString();
                      String month = months[dateTime.month - 1];
                      switch (list[index].type) {
                        case 'like':
                          {
                            postIndex = myPosts.indexWhere((element) =>
                                element.post_id == list[index].postId);
                            PostModel post = myPosts[postIndex];
                            tile = Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (!list[index].read!)
                                    ? Colors.orange[100]
                                    : Colors.white,
                                border: Border.all(
                                    color: Colors.grey,
                                    width: displayWidth(context) * 0.001),
                              ),
                              height: displayHeight(context) * 0.105,
                              width: displayWidth(context) * 0.95,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red[600],
                                      ),
                                      Text(
                                        '${user.username} liked your post',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                displayWidth(context) * 0.036),
                                      ),
                                      (postIndex != -1)
                                          ? CachedNetworkImage(
                                              imageUrl: post.image,
                                              height: displayHeight(context) * 0.05,
                                              width: displayWidth(context) * 0.1,
                                              fit: BoxFit.cover,
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Opacity(opacity: 0.0,child: Divider(height: displayHeight(context)*0.01,)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        (ifPostedToday(list[index].time!))?
                                        Text(displayTime(list[index].time!),style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: displayWidth(context) * 0.0285,
                                        ))
                                            :Text(
                                          '${day} ${month} ${year}',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            fontSize: displayWidth(context) * 0.0285,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          break;
                        case 'comment':
                          {
                            int postIndex = myPosts.indexWhere((element) =>
                                element.post_id == list[index].postId);
                            PostModel post = myPosts[postIndex];
                            tile = Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (!list[index].read!)
                                    ? Colors.orange[100]
                                    : Colors.white,
                                border: Border.all(
                                    color: Colors.grey,
                                    width: displayWidth(context) * 0.001),
                              ),
                              height: displayHeight(context) * 0.105,
                              width: displayWidth(context) * 0.95,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(
                                        Icons.comment_outlined,
                                        color: Colors.indigo,
                                      ),
                                      Text(
                                        '${user.username} commented on your post',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                displayWidth(context) * 0.036),
                                      ),
                                      (postIndex != -1)
                                          ? CachedNetworkImage(
                                              imageUrl: post.image,
                                              height: displayHeight(context) * 0.05,
                                              width: displayWidth(context) * 0.1,
                                              fit: BoxFit.cover,
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),

                                  Opacity(opacity: 0.0,child: Divider(height: displayHeight(context)*0.01,)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        (ifPostedToday(list[index].time!))?
                                        Text(displayTime(list[index].time!),style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: displayWidth(context) * 0.0285,
                                        ))
                                            :Text(
                                          '${day} ${month} ${year}',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            fontSize: displayWidth(context) * 0.0285,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )

                                ],
                              ),
                            );
                          }
                          break;
                        case 'follow':
                          {
                            tile = Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (!list[index].read!)
                                    ? Colors.orange[100]
                                    : Colors.white,
                                border: Border.all(
                                    color: Colors.grey,
                                    width: displayWidth(context) * 0.001),
                              ),
                              height: displayHeight(context) * 0.105,
                              width: displayWidth(context) * 0.95,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        'images/follow.png',
                                        height: displayHeight(context) * 0.05,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        '${user.username} started following you',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                displayWidth(context) * 0.036),
                                      ),
                                      (user.dp != '')
                                          ? CachedNetworkImage(
                                              imageUrl: user.dp,
                                              height: displayHeight(context) * 0.05,
                                              width: displayWidth(context) * 0.1,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              height: displayHeight(context) * 0.05,
                                              width: displayWidth(context) * 0.1,
                                              color: Colors.grey[200],
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.orange[400],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Opacity(opacity: 0.0,child: Divider(height: displayHeight(context)*0.01,)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        (ifPostedToday(list[index].time!))?
                                        Text(displayTime(list[index].time!),style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: displayWidth(context) * 0.0285,
                                        ))
                                            :Text(
                                          '${day} ${month} ${year}',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            fontSize: displayWidth(context) * 0.0285,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )



                                ],
                              ),
                            );
                          }
                          break;
                        default:
                          {}
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Slidable(
                          dragStartBehavior: DragStartBehavior.start,
                          child: InkWell(
                              onTap: () {
                                if (list[index].type == 'like') {
                                  if (index == -1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Post does not exist')));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              viewMyPostScreen(
                                            index: postIndex!,
                                            myUid: currentUser.uid,
                                          ),
                                        ));
                                  }
                                } else if (list[index].type == 'comment') {
                                  if (index == -1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Post does not exist')));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CommentScreenForMyPosts(
                                            postId: list[index].postId,
                                            postOwner: user,
                                          ),
                                        ));
                                  }
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => userProfile(
                                          uid: list[index].notifierUid,
                                        ),
                                      ));
                                }
                              },
                              child: tile!),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Provider.of<manager>(context, listen: false)
                                      .readNotification(currentUser.uid,
                                          list[index].notificationId!);
                                },
                                flex: 1,
                                backgroundColor: Colors.green[200]!,
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                                label: 'Read',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  Provider.of<manager>(context, listen: false)
                                      .deleteNotification(currentUser.uid,
                                          list[index].notificationId!);
                                },
                                flex: 1,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: list.length,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
