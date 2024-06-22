import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/utils/util_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:wave/data/notification_data.dart';
import 'package:wave/models/notification_model.dart' as not;

class PostDetailScreen extends StatefulWidget {
  PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final CarouselController _carouselController = CarouselController();
  Post post = Get.arguments['post'];
  User poster = Get.arguments['poster'];
  String? firstMentioned = Get.arguments['mentionedUserId'];

  User? userMentioned;
  int currentImage = 0;

  Future<void> getMentionedUserDetail() async {
    userMentioned = await UserData.getUser(userID: firstMentioned!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (firstMentioned != null) {
      getMentionedUserDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: displayHeight(context) * 0.07,
        // color: Colors.blue,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Like count and like icon
            StreamBuilder(
              stream: Database.getPostLikesDatabase(post.id).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> likes) {
                if ((likes.connectionState == ConnectionState.active ||
                        likes.connectionState == ConnectionState.done) &&
                    likes.hasData) {
                  // Check if current user has liked the post
                  bool hasLiked = likes.data!.docs.any((element) {
                    return (element.id ==
                        fb.FirebaseAuth.instance.currentUser!.uid);
                  });
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () async {
                            if (hasLiked) {
                              await PostData.unLikePostWithId(
                                  postId: post.id,
                                  userId: fb
                                      .FirebaseAuth.instance.currentUser!.uid);
                            } else {
                              await PostData.likePostWithId(
                                  postId: post.id,
                                  userId: fb
                                      .FirebaseAuth.instance.currentUser!.uid);
                              bool hasAlreadySentNotification =
                                  await PostData.alreadySentNotificationForThis(
                                      postId: post.id, posterId: post.userId);
                              if (!hasAlreadySentNotification) {
                                not.Notification notification =
                                    not.Notification(
                                        type: 'like',
                                        id: "id",
                                        createdAt: DateTime.now(),
                                        seen: false,
                                        postId: post.id,
                                        userWhoLiked: fb.FirebaseAuth.instance
                                            .currentUser!.uid,
                                        forUser: poster.id);
                                NotificationData.createNotification(
                                    notification: notification);
                              }
                            }
                          },
                          child: Icon(
                            hasLiked ? BoxIcons.bxs_like : BoxIcons.bx_like,
                            size: 22,
                            color: CustomColor.primaryColor,
                          )),
                      const SizedBox(width: 8),
                      Text(
                        '${likes.data!.docs.length}',
                        style: TextStyle(
                            fontFamily: CustomFont.poppins,
                            color: CustomColor.primaryColor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () async {
                            await PostData.likePostWithId(
                                postId: post.id,
                                userId:
                                    fb.FirebaseAuth.instance.currentUser!.uid);
                          },
                          child: Icon(
                            BoxIcons.bx_like,
                            size: 22,
                            color: CustomColor.primaryColor,
                          )),
                      const SizedBox(width: 8),
                      Text(
                        '${0}',
                        style: TextStyle(
                            fontFamily: CustomFont.poppins,
                            color: CustomColor.primaryColor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  );
                }
              },
            ),

            // Comment icon and comment count
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.listCommentsScreen, arguments: post.id);
              },
              child: StreamBuilder(
                stream: Database.getPostCommentsDatabase(post.id).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> commentSnapshot) {
                  if ((commentSnapshot.connectionState ==
                              ConnectionState.active ||
                          commentSnapshot.connectionState ==
                              ConnectionState.done) &&
                      commentSnapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Image.asset(
                            CustomIcon.commentIcon,
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.50),
                          child: Text(
                            '${commentSnapshot.data!.docs.length}',
                            style: TextStyle(
                                fontFamily: CustomFont.poppins,
                                color: CustomColor.primaryColor,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Image.asset(
                            CustomIcon.commentIcon,
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.50),
                          child: Text(
                            '0',
                            style: TextStyle(
                                fontFamily: CustomFont.poppins,
                                color: CustomColor.primaryColor,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Image.asset(
                CustomIcon.shareIcon,
                height: 22,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Consumer<UserDataController>(
                  builder: (context, userDataController, child) {
                    bool saved = (userDataController.user!.savedPosts != null &&
                        userDataController.user!.savedPosts!.contains(post.id));
                    return InkWell(
                      onTap: () async {
                        if (!saved) {
                          CustomResponse customResponse =
                              await userDataController.savePost(post.id);
                          if (!customResponse.responseStatus) {
                            "${customResponse.response}".printError();
                          }
                        } else {
                          CustomResponse customResponse =
                              await userDataController.unsavePost(post.id);
                          if (!customResponse.responseStatus) {
                            "${customResponse.response}".printError();
                          }
                        }
                      },
                      child: Icon(
                        saved ? Icons.bookmark : Icons.bookmark_add_outlined,
                        size: 20,
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${poster.username}\'s post',
          style: TextStyle(
            fontFamily: CustomFont.poppins,
            fontSize: 16.5,
            letterSpacing: -0.1,
          ),
        ),
        elevation: 0,
        backgroundColor: CustomColor.primaryBackGround,
      ),
      backgroundColor: CustomColor.primaryBackGround,
      body: SafeArea(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: displayHeight(context) * 0.055,
                width: displayWidth(context) * 0.11,
                child: (poster.displayPicture != null &&
                        poster.displayPicture!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: poster.displayPicture!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey.shade300,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          CustomIcon.profileFullIcon,
                          color: Colors.black54,
                          height: 25,
                        ),
                      ),
              ),
              title: (post.mentions.isNotEmpty)
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          poster.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 11.5,
                              fontFamily: CustomFont.poppins),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Visibility(
                            visible: poster.verified,
                            child: Image.asset(
                              CustomIcon.verifiedIcon,
                              height: 12,
                            )),
                        Text(
                          " is with ",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 11.5,
                              fontFamily: CustomFont.poppins),
                        ),
                        Text(
                          userMentioned != null ? userMentioned!.name : "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 11.5,
                              fontFamily: CustomFont.poppins),
                        ),
                      ],
                    )
                  : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          poster.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 11.5,
                              fontFamily: CustomFont.poppins),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Visibility(
                            visible: poster.verified,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Image.asset(
                                CustomIcon.verifiedIcon,
                                height: 12,
                              ),
                            ))
                      ],
                    ),
              subtitle: Text(
                timeAgo(post.createdAt),
                style: TextStyle(
                    fontSize: 11.5,
                    fontFamily: CustomFont.poppins,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500),
              ),
              visualDensity: const VisualDensity(vertical: 0, horizontal: -1),
            ),
            const SizedBox(height: 12),
            Visibility(
              visible: post.caption.isNotEmpty,
              child: Text(
                post.caption,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12, fontFamily: CustomFont.poppins),
              ),
            ),
            Visibility(
              visible: post.caption.isNotEmpty,
              child: const SizedBox(
                height: 15,
              ),
            ),
            post.postList.length == 1
                ? CachedNetworkImage(
                    imageUrl: post.postList.first.url,
                    height: Get.height * 0.55,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                : CarouselSlider(
                    carouselController: _carouselController,
                    items: post.postList.map((pc) {
                      if (pc.type == 'image') {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            height: displayHeight(context) * 0.55,
                            // width: double.infinity,
                            imageUrl: pc.url,
                            fit: BoxFit.contain,
                          ),
                        );
                      } else {
                        // TODO : Render video
                        return const SizedBox();
                      }
                    }).toList(),
                    options: CarouselOptions(
                      height: displayHeight(context) * 0.53,
                      viewportFraction: 0.9,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      pauseAutoPlayOnManualNavigate: true,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentImage = index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    )),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: post.postList.length > 1,
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: currentImage,
                  count: post.postList.length,
                  effect: WormEffect(
                      activeDotColor: CustomColor.primaryColor, dotHeight: 8),
                  onDotClicked: (index) {
                    _carouselController.animateToPage(index);
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
