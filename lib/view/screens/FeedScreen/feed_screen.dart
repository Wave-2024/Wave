import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:badges/badges.dart' as badge;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/controllers/PostController/feed_post_controller.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/constants/preferences.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/reusable_components/feedbox.dart';
import 'package:wave/models/notification_model.dart' as notification;

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key});

  Future<void> fetchPosts() async {
    "Refreshed".printInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchPosts,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: CustomColor.primaryBackGround,
                title: Text(
                  "Wave",
                  style: TextStyle(fontFamily: CustomFont.alex, fontSize: 40),
                ),
                floating: true,
                snap: true,
                elevation: 0,
                actions: [
                  Consumer<UserDataController>(
                    builder: (context, userController, child) {
                      return StreamBuilder(
                        stream: Database.getNotificationDatabase(
                                userController.user!.id)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> notificationSnapshot) {
                          int unseenNotification = 4;
                          if ((notificationSnapshot.connectionState ==
                                      ConnectionState.active ||
                                  notificationSnapshot.connectionState ==
                                      ConnectionState.done) &&
                              notificationSnapshot.hasData) {
                            unseenNotification = notificationSnapshot.data!.docs
                                .where((element) =>
                                    !(notification.Notification.fromMap(element
                                            .data()! as Map<String, dynamic>)
                                        .seen))
                                .toList()
                                .length;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.notificationScreen);
                              },
                              child: badge.Badge(
                                position: badge.BadgePosition.topEnd(end: -4),
                                badgeAnimation:
                                    const badge.BadgeAnimation.slide(),
                                badgeStyle: const badge.BadgeStyle(
                                    badgeColor: Color(0xfb16db65)),
                                badgeContent: Text(
                                  unseenNotification.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                showBadge: unseenNotification > 0,
                                child: Image.asset(
                                  CustomIcon.notificationIcon,
                                  height: 25,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(left: 14.0, right: 8, top: 2),
                  // color: Colors.amber.shade100,
                  height: displayHeight(context) * 0.12,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 30,
                              backgroundImage:
                                  AssetImage(CustomIcon.addStoryIcon),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "You",
                              style: TextStyle(
                                  fontFamily: CustomFont.poppins, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blue.shade100,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "alpha3109",
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 10),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer2<FeedPostController, UserDataController>(
                  builder: (context, feedController, userController, child) {
                    if (feedController.postState == POSTS_STATE.ABSENT) {
                      feedController.getPosts(userController.user!.following);
                    }
                    switch (feedController.postState) {
                      case POSTS_STATE.ABSENT:
                        return const Center(child: CircularProgressIndicator());
                      case POSTS_STATE.LOADING:
                        return const Center(child: CircularProgressIndicator());

                      case POSTS_STATE.PRESENT:
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: feedController.posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder<User>(
                              future: UserData.getUser(
                                  userID: feedController.posts[index].userId),
                              builder: (context, AsyncSnapshot<User> user) {
                                if (user.connectionState ==
                                        ConnectionState.done &&
                                    user.hasData) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: FeedBox(
                                        post: feedController.posts[index],
                                        poster: user.data!),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
