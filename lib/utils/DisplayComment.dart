import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Posts/CommentScreens/ReplyCommentScreen.dart';
import 'package:nexus/screen/Posts/usersWhoLikedScreen.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

import 'devicesize.dart';

class DisplayCommentBox extends StatelessWidget {
  String commentId;
  String postId;
  String comment;
  String uid;
  List<dynamic> replies;
  List<dynamic> likes;
  DateTime commentTime;

  DisplayCommentBox(
      {required this.uid,
      required this.postId,
      required this.commentTime,
      required this.replies,
      required this.likes,
      required this.comment,
      required this.commentId});

  likeThisComment(String postId, String commentId, String myUid,
      List<dynamic> likes) async {
    if (!(likes.contains(myUid))) {
      print('reached this fun');
      likes.add(myUid);
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({'likes': likes});
    }
  }

  disLikeThisComment(String postId, String commentId, String myUid,
      List<dynamic> likes) async {
    if (likes.contains(myUid)) {
      likes.remove(myUid);
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({'likes': likes});
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    NexusUser? user = Provider.of<manager>(context).fetchAllUsers[uid];
    bool isThisMyPost = Provider.of<manager>(context).isMyPost(postId);
    String timeDiff = differenceOfTimeForComment(DateTime.now(), commentTime);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: (user!.dp != '')
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: displayHeight(context) * 0.042,
                          width: displayWidth(context) * 0.078,
                          fit: BoxFit.cover,
                          imageUrl: user.dp,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.orange[300],
                        size: displayWidth(context) * 0.076,
                      ),
              ),
            ),
            (user.followers.length >= 5)
                ? Icon(
                    Icons.verified,
                    color: Colors.orange[400],
                    size: displayWidth(context) * 0.044,
                  )
                : const SizedBox(
                    width: 0,
                  ),
            Opacity(
                opacity: 0.0,
                child: VerticalDivider(
                  width: displayWidth(context) * 0.01,
                )),
            Expanded(
              child: Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                //color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: printComment(context, user.username, comment),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (!likes.contains(currentUser!.uid)) {
                  likeThisComment(postId, commentId, currentUser.uid, likes);
                } else {
                  disLikeThisComment(postId, commentId, currentUser.uid, likes);
                }
              },
              icon: (likes.contains(currentUser!.uid))
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              color: (likes.contains(currentUser.uid))
                  ? Colors.pink
                  : Colors.black54,
              iconSize: displayWidth(context) * 0.045,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 55.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                timeDiff,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: displayWidth(context) * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: VerticalDivider(
                  width: displayWidth(context) * 0.06,
                ),
              ),
              InkWell(
                onTap: () {
                  if (likes.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => usersWhoLikedScreen(
                            usersWhoLiked: likes,
                          ),
                        ));
                  }
                },
                child: Text(
                  (likes.isEmpty)
                      ? '${likes.length} like'
                      : '${likes.length} likes',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: displayWidth(context) * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: VerticalDivider(
                  width: displayWidth(context) * 0.06,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReplyCommentScreen(
                          replies: replies,
                          commenterId: uid,
                          commentId: commentId,
                          myUid: currentUser.uid,
                          postId: postId,
                          rootComment: comment,
                        ),
                      ));
                },
                child: Text(
                  (replies.isEmpty) ? 'Reply' : '${replies.length} replies',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: displayWidth(context) * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: VerticalDivider(
                  width: displayWidth(context) * 0.035,
                ),
              ),
              (isThisMyPost || uid == currentUser.uid)
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('Delete Comment'),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: TextButton(
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: TextButton.icon(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(postId)
                                          .collection('comments')
                                          .doc(commentId)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: const Text('Yes',
                                        style:
                                            TextStyle(color: Colors.black87)),
                                  )),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                      iconSize: displayWidth(context) * 0.04,
                      color: Colors.black45,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
