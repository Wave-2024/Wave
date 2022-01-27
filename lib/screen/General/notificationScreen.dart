import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/NotificationModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Posts/view/viewMyPostsScreen.dart';
import 'package:nexus/utils/devicesize.dart';
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
            padding: const EdgeInsets.only(top: 16.0, bottom: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // TODO -> Update all the notification status to read
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
                        child: Center(
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
                      ListTile? listTile;
                      switch (list[index].type) {
                        case 'like':
                          {
                            NexusUser user = allUsers[list[index].notifierUid]!;
                            int postIndex = myPosts.indexWhere((element) =>
                                element.post_id == list[index].postId);
                            PostModel post = myPosts[postIndex];
                            listTile = ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => viewMyPostScreen(
                                        index: postIndex,
                                        myUid: currentUser.uid,
                                      ),
                                    ));
                              },
                              trailing: CachedNetworkImage(
                                imageUrl: post.image,
                                height: displayHeight(context) * 0.05,
                                width: displayWidth(context) * 0.1,
                                fit: BoxFit.cover,
                              ),
                              tileColor: (list[index].read!)
                                  ? Colors.white
                                  : Colors.orange[100],
                              leading: Icon(
                                Icons.favorite,
                                color: Colors.red[600],
                              ),
                              title: Text(
                                '${user.username} liked your post',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: displayWidth(context) * 0.036),
                              ),
                            );
                          }
                      }
                      return listTile!;
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
