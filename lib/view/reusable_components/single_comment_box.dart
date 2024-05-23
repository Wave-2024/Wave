import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/comment_post_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/util_functions.dart';
import '../../models/user_model.dart';
import '../../utils/constants/custom_icons.dart';

class SingleCommentBox extends StatelessWidget {
  Comment comment;

  SingleCommentBox({required this.comment});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: UserData.getUser(userID: comment.userId),
      builder: (context, AsyncSnapshot<User> user) {
        if (user.connectionState == ConnectionState.done && user.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: user.data!.displayPicture != null &&
                                user.data!.displayPicture!.isNotEmpty
                            ? CachedNetworkImageProvider(
                                user.data!.displayPicture!)
                            : null,
                        child: user.data!.displayPicture == null ||
                                user.data!.displayPicture!.isEmpty
                            ? Image.asset(
                                CustomIcon.profileFullIcon,
                                height: 12,
                              )
                            : null,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            user.data!.name,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: CustomFont.poppins),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Visibility(
                              visible: user.data!.verified,
                              child: Image.asset(
                                CustomIcon.verifiedIcon,
                                height: 11.2,
                              ))
                        ],
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        "${getMonthName(comment.createdAt.month)} ${comment.createdAt.day} '${comment.createdAt.year}",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: CustomFont.poppins,
                            fontSize: 10),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    comment.comment,
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: CustomFont.poppins,
                        fontSize: 12),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: Database.getPostCommentsLikesDatabase(
                                comment.postId, comment.id)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> likesSnapshot) {
                          bool hasLiked = false;
                          if ((likesSnapshot.connectionState ==
                                      ConnectionState.active ||
                                  likesSnapshot.connectionState ==
                                      ConnectionState.done) &&
                              likesSnapshot.hasData) {
                            hasLiked = likesSnapshot.data!.docs.any((element) {
                              return (element.id ==
                                  fb.FirebaseAuth.instance.currentUser!.uid);
                            });
                          }
                          return InkWell(
                            onTap: () async {
                              if (hasLiked) {
                                await PostData.unlikeOnComment(
                                    postId: comment.postId,
                                    commentId: comment.id,
                                    userId: fb.FirebaseAuth.instance
                                        .currentUser!.uid);
                              } else {
                                await PostData.likeOnComment(
                                    postId: comment.postId,
                                    commentId: comment.id,
                                    userId: fb.FirebaseAuth.instance
                                        .currentUser!.uid);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  hasLiked
                                      ? Bootstrap.heart_fill
                                      : Bootstrap.heart,
                                  size: 18,
                                  color: Colors.grey.shade800,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ((likesSnapshot.connectionState ==
                                                ConnectionState.active ||
                                            likesSnapshot.connectionState ==
                                                ConnectionState.done) &&
                                        likesSnapshot.hasData)
                                    ? Text(
                                        "${likesSnapshot.data!.docs.length} Likes",
                                        style: TextStyle(
                                            fontFamily: CustomFont.poppins,
                                            fontSize: 11.5,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        "0 Likes",
                                        style: TextStyle(
                                            fontFamily: CustomFont.poppins,
                                            fontSize: 11.5,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          "Tapped to reply".printInfo();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Bootstrap.reply,
                              size: 20,
                              color: Colors.grey.shade800,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Reply",
                              style: TextStyle(
                                  fontFamily: CustomFont.poppins,
                                  fontSize: 11.5,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
