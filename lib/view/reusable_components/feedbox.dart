import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as time;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:wave/data/notification_data.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/models/notification_model.dart' as not;
import 'package:wave/models/post_content_model.dart';
import 'package:wave/models/post_model.dart';
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
import 'package:wave/view/screens/FeedScreen/list_comment_screen.dart';

class FeedBox extends StatelessWidget {
  final Post post;
  final User poster;
  const FeedBox({super.key, required this.post, required this.poster});

  Widget decideMediaBox(double height) {
    List<PostContent> posts = post.postList;
    // If number of media files is 0
    if (posts.isEmpty) {
      return const SizedBox();
    } // If number of media files is 1
    else if (posts.length == 1) {
      if (posts.first.type == "image") {
        return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
                imageUrl: posts.first.url, fit: BoxFit.cover));
      } else {
        // TODO : Handle video files
        return const SizedBox();
      }
    } // If number of media files is 2
    else if (posts.length == 2) {
      return CarouselSlider(
          items: posts.map((pc) {
            if (pc.type == 'image') {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  height: height,
                  width: double.infinity,
                  imageUrl: pc.url,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              // TODO : Render video
              return const SizedBox();
            }
          }).toList(),
          options: CarouselOptions(
            height: height,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            pauseAutoPlayOnManualNavigate: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, reason) {},
            scrollDirection: Axis.horizontal,
          ));
    }
    // If number of media files is 3
    else if (posts.length == 3) {
      return StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 3,
            mainAxisCellCount: 1.2,
            child: (posts[0].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[0].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1.2,
            child: (posts[1].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[1].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player,
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1.2,
            child: (posts[2].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[2].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player ,
          ),
        ],
      );
    }
    // If number of media files is 4
    else if (posts.length == 4) {
      return StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 5,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: (posts[0].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[0].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: (posts[1].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[1].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player,
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: (posts[2].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[2].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player ,
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: (posts[3].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[3].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player ,
          ),
        ],
      );
    }
    // If number of media files is 5
    else if (posts.length == 5) {
      return StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2.1,
            child: (posts[0].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[0].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player ,,
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1.2,
            child: (posts[1].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[1].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player ,,
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: (posts[2].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[2].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player ,,
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: (posts[3].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[3].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player ,,
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: (posts[4].type == 'image')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: posts[4].url,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(), // TODO : Video player ,,
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeAgo = calculateTimeAgo(post.createdAt);
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
                        " is with",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 11.5,
                            fontFamily: CustomFont.poppins),
                      ),
                      Text(
                        " Aradhana Roy",
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
                          visible: !poster.verified,
                          child: Image.asset(
                            CustomIcon.verifiedIcon,
                            height: 12,
                          ))
                    ],
                  ),
            trailing: IconButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return MoreOptionsForFeedPost(post: post);
                  },
                );
              },
              iconSize: 24,
              icon: const Icon(AntDesign.more_outline),
            ),
            subtitle: Text(
              '${time.format(timeAgo, locale: 'en_short').substring(1)} ago',
              style: TextStyle(
                  fontSize: 11.5,
                  fontFamily: CustomFont.poppins,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500),
            ),
            visualDensity: const VisualDensity(vertical: 0, horizontal: -1),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: (post.postList.length == 2)
                ? const EdgeInsets.only(left: 20)
                : const EdgeInsets.all(0),
            child: Text(
              post.caption,
              maxLines: (post.postList.isEmpty) ? 8 : 4,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, fontFamily: CustomFont.poppins),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          decideMediaBox(displayHeight(context) * 0.47),
          SizedBox(
            height: post.postList.isEmpty ? 0 : 15,
          ),
          Row(
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
                                    userId: fb.FirebaseAuth.instance
                                        .currentUser!.uid);
                              } else {
                                await PostData.likePostWithId(
                                    postId: post.id,
                                    userId: fb.FirebaseAuth.instance
                                        .currentUser!.uid);
                                bool hasAlreadySentNotification = await PostData
                                    .alreadySentNotificationForThis(
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
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Icon(
                  Icons.bookmark_add_outlined,
                  size: 20,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
