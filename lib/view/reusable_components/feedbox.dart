import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/notification_data.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/notification_model.dart' as not;
import 'package:wave/models/post_content_model.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/device_size.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/utils/util_functions.dart';
import 'package:wave/view/reusable_components/more_option_feed.dart';
import 'package:wave/view/reusable_components/video_play.dart';

class FeedBox extends StatefulWidget {
  final Post post;
  final User poster;
  String? firstMentioned;
  FeedBox(
      {super.key,
      required this.post,
      required this.poster,
      this.firstMentioned});

  @override
  State<FeedBox> createState() => _FeedBoxState();
}

class _FeedBoxState extends State<FeedBox> {
  Widget decideMediaBox(double height, BuildContext context) {
    List<PostContent> posts = widget.post.postList;
    // If number of media files is 0
    if (posts.isEmpty) {
      return const SizedBox.shrink();
    } // If number of media files is 1
    else if (posts.length == 1) {
      if (posts.first.type == "image") {
        return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: posts.first.url,
              fit: (posts.first.isMediaLandscape)
                  ? BoxFit.contain
                  : BoxFit.cover,
              // height: height,
              width: displayWidth(context),
            ));
      } else {
        // TODO : Handle video files
        return VideoPlayerWidget(url: posts.first.url);
      }
    } // If number of media files is 2

    else {
      return SizedBox(
        height: height,
        child: PageView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            if (posts[index].type == 'image') {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: posts[index].url,
                  fit: (posts[index].isMediaLandscape)
                      ? BoxFit.contain
                      : BoxFit.cover,
                ),
              );
            } else {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                          width: height *
                              (3 / 2), // Assuming 16:9 aspect ratio for videos
                          height: height,
                          child: VideoPlayerWidget(url: posts[index].url))));
            }
          },
        ),
      );
    }
  }

  User? userMentioned;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.firstMentioned != null) {
      getMentionedUserDetail();
    }
  }

  Future<void> getMentionedUserDetail() async {
    userMentioned = await UserData.getUser(userID: widget.firstMentioned!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.profileScreen,
                    arguments: widget.poster.id);
              },
              child: SizedBox(
                height: displayHeight(context) * 0.055,
                width: displayWidth(context) * 0.11,
                child: (widget.poster.displayPicture != null &&
                        widget.poster.displayPicture!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: widget.poster.displayPicture!,
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
            ),
            title: (widget.post.mentions.isNotEmpty)
                ? Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        widget.poster.name,
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
                          visible: widget.poster.verified,
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
                : InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.profileScreen,
                          arguments: widget.poster.id);
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.poster.name,
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
                            visible: widget.poster.verified,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Image.asset(
                                CustomIcon.verifiedIcon,
                                height: 12,
                              ),
                            ))
                      ],
                    ),
                  ),
            trailing: IconButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return MoreOptionsForFeedPost(post: widget.post);
                  },
                );
              },
              iconSize: 24,
              icon: const Icon(AntDesign.more_outline),
            ),
            subtitle: Text(
              timeAgo(widget.post.createdAt),
              style: TextStyle(
                  fontSize: 11.5,
                  fontFamily: CustomFont.poppins,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500),
            ),
            visualDensity: const VisualDensity(vertical: 0, horizontal: -1),
          ),
          SizedBox(height: widget.post.caption.isEmpty ? 0 : 12),
          Text(
            widget.post.caption,
            maxLines: (widget.post.postList.isEmpty) ? 8 : 4,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontFamily: CustomFont.poppins),
          ),
          SizedBox(
            height: widget.post.caption.isEmpty ? 0 : 15,
          ),
          Container(
            height: displayHeight(context) * 0.475,
            width: displayWidth(context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black26, width: 0.25)),
            child: InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.postDetailScreen, arguments: {
                    'post': widget.post,
                    'poster': widget.poster
                  });
                },
                child: decideMediaBox(displayHeight(context) * 0.47, context)),
          ),
          SizedBox(
            height: widget.post.postList.isEmpty ? 0 : 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Like count and like icon
              StreamBuilder(
                stream:
                    Database.getPostLikesDatabase(widget.post.id).snapshots(),
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
                                    postId: widget.post.id,
                                    userId: fb.FirebaseAuth.instance
                                        .currentUser!.uid);
                              } else {
                                await PostData.likePostWithId(
                                    postId: widget.post.id,
                                    userId: fb.FirebaseAuth.instance
                                        .currentUser!.uid);
                                bool hasAlreadySentNotification = await PostData
                                    .alreadySentNotificationForThis(
                                        postId: widget.post.id,
                                        posterId: widget.post.userId);
                                if (!hasAlreadySentNotification) {
                                  not.Notification notification =
                                      not.Notification(
                                          type: 'like',
                                          id: "id",
                                          createdAt: DateTime.now(),
                                          seen: false,
                                          postId: widget.post.id,
                                          userWhoLiked: fb.FirebaseAuth.instance
                                              .currentUser!.uid,
                                          forUser: widget.poster.id);
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
                                  postId: widget.post.id,
                                  userId: fb
                                      .FirebaseAuth.instance.currentUser!.uid);
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
                  Get.toNamed(AppRoutes.listCommentsScreen,
                      arguments: widget.post.id);
                },
                child: StreamBuilder(
                  stream: Database.getPostCommentsDatabase(widget.post.id)
                      .snapshots(),
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
                      bool saved =
                          (userDataController.user!.savedPosts != null &&
                              userDataController.user!.savedPosts!
                                  .contains(widget.post.id));
                      return InkWell(
                        onTap: () async {
                          if (!saved) {
                            CustomResponse customResponse =
                                await userDataController
                                    .savePost(widget.post.id);
                            if (!customResponse.responseStatus) {
                              "${customResponse.response}".printError();
                            }
                          } else {
                            CustomResponse customResponse =
                                await userDataController
                                    .unsavePost(widget.post.id);
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
          )
        ],
      ),
    );
  }
}
