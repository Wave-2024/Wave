import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/controllers/PostController/feed_post_controller.dart';
import 'package:wave/data/notification_data.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/models/comment_post_model.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/models/notification_model.dart' as notification;
import 'package:wave/view/reusable_components/custom_textbox_for_comment.dart';
import 'package:wave/view/reusable_components/single_comment_box.dart';

class ListCommentsScreen extends StatefulWidget {
  const ListCommentsScreen({super.key});

  @override
  State<ListCommentsScreen> createState() => _ListCommentsScreenState();
}

class _ListCommentsScreenState extends State<ListCommentsScreen> {
  String? postId;
  int commentLimit = 20;
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postId = Get.arguments as String;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(
            fontFamily: CustomFont.poppins,
            fontSize: 16.5,
            letterSpacing: -0.1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: CustomColor.primaryBackGround,
      ),
      body: SafeArea(child: Consumer2<FeedPostController, UserDataController>(
        builder: (context, feedController, userController, child) {
          return Container(
            child: CustomTextBoxForComments(
              commentController: commentController,
              sendWidget: Icon(Icons.send),
              sendButtonMethod: () async {
                if (commentController.text.trim().isNotEmpty) {
                  CustomResponse customResponse =
                      await PostData.commentOnPostWithId(
                          postId: postId,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          commentString: commentController.text.trim());

                  if (customResponse.responseStatus) {
                    String comment = commentController.text.trim();
                    commentController.clear();
                    Get.showSnackbar(const GetSnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                      borderRadius: 5,
                      title: "Success",
                      message: "Your comment was posted",
                    ));
                    Post post = await PostData.getPost(postId!);
                    notification.Notification not = notification.Notification(
                        createdAt: DateTime.now(),
                        forUser: post.userId,
                        seen: false,
                        type: "comment",
                        id: "",
                        comment: comment,
                        postId: postId,
                        commentId: customResponse.response.toString(),
                        userWhoCommented:
                            FirebaseAuth.instance.currentUser!.uid);
                    NotificationData.createNotification(notification: not);
                  } else {
                    Get.showSnackbar(GetSnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: CustomColor.errorColor,
                      borderRadius: 5,
                      title: "Failed",
                      message: "Your comment was not posted",
                    ));
                  }
                } else {
                  Get.showSnackbar(GetSnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: CustomColor.errorColor,
                    borderRadius: 5,
                    title: "Empty Comment",
                    message: "Cannot post empty comment",
                  ));
                }
              },
              userImage: (userController.user!.displayPicture != null &&
                      userController.user!.displayPicture!.isNotEmpty)
                  ? CachedNetworkImageProvider(
                      userController.user!.displayPicture!)
                  : AssetImage(CustomIcon.profileFullIcon) as ImageProvider,
              child: StreamBuilder(
                stream: Database.getPostCommentsDatabase(postId!)
                    .limit(50)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> comments) {
                  if ((comments.connectionState == ConnectionState.active ||
                          comments.connectionState == ConnectionState.done) &&
                      comments.hasData) {
                    return ListView.builder(
                      itemCount: comments.data!.docs.length,
                      itemBuilder: (context, index) {
                        return SingleCommentBox(
                          comment: Comment.fromMap(comments.data!.docs[index]
                              .data() as Map<String, dynamic>),
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          );
        },
      )),
    );
  }
}
