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

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser!;
    List<NotificationModel> list =
        Provider.of<usersProvider>(context).fetchNotifications;
    Map<String, NexusUser> allUsers =
        Provider.of<usersProvider>(context).fetchAllUsers;
    List<PostModel> myPosts =
        Provider.of<usersProvider>(context).fetchMyPostsList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
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
                      Provider.of<usersProvider>(context, listen: false)
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
                  Opacity(opacity: 0.0, child: Divider()),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Container? tile;
                      int? postIndex;
                      NexusUser user = allUsers[list[index].notifierUid]!;
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
                              height: displayHeight(context) * 0.08,
                              width: displayWidth(context) * 0.95,
                              child: Row(
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
                                  CachedNetworkImage(
                                    imageUrl: post.image,
                                    height: displayHeight(context) * 0.05,
                                    width: displayWidth(context) * 0.1,
                                    fit: BoxFit.cover,
                                  ),
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
                              height: displayHeight(context) * 0.08,
                              width: displayWidth(context) * 0.95,
                              child: Row(
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
                                  CachedNetworkImage(
                                    imageUrl: post.image,
                                    height: displayHeight(context) * 0.05,
                                    width: displayWidth(context) * 0.1,
                                    fit: BoxFit.cover,
                                  ),
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
                              height: displayHeight(context) * 0.08,
                              width: displayWidth(context) * 0.95,
                              child: Row(
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
                                  CachedNetworkImage(
                                    imageUrl: user.dp,
                                    height: displayHeight(context) * 0.05,
                                    width: displayWidth(context) * 0.1,
                                    fit: BoxFit.cover,
                                  ),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => viewMyPostScreen(
                                          index: postIndex!,
                                          myUid: currentUser.uid,
                                        ),
                                      ));
                                } else if (list[index].type == 'comment') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CommentScreenForMyPosts(
                                          postId: list[index].postId,
                                          postOwner: user,
                                        ),
                                      ));
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
                                  Provider.of<usersProvider>(context,
                                          listen: false)
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
                                  Provider.of<usersProvider>(context,
                                          listen: false)
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
