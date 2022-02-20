import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/DisplayComment.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:nexus/utils/reportContainer.dart';
import 'package:provider/provider.dart';

import '../usersWhoLikedScreen.dart';

class CommentScreenForMyPosts extends StatefulWidget {
  final String? postId;
  final NexusUser? postOwner;
  CommentScreenForMyPosts({this.postId, this.postOwner});

  @override
  State<CommentScreenForMyPosts> createState() => _postDetailForMyPostsState();
}

class _postDetailForMyPostsState extends State<CommentScreenForMyPosts> {
  User? currentUser;
  TextEditingController? commentController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    commentController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NexusUser? myProfile = Provider.of<manager>(context)
        .fetchAllUsers[currentUser!.uid.toString()];
    PostModel? postDetail =
        Provider.of<manager>(context).fetchMyPostsMap[widget.postId];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: CommentBox(
          backgroundColor: Colors.white,
          formKey: formKey,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            await Provider.of<manager>(context, listen: false).commentOnPost(
                currentUser!.uid,
                currentUser!.uid,
                postDetail!.post_id,
                commentController!.text.toString());
            setState(() {
              commentController!.clear();
            });
          },
          userImage:
              (myProfile!.dp != '') ? myProfile.dp : constants().fetchDpUrl,
          commentController: commentController,
          labelText: "Your Comment",
          sendWidget: Icon(
            Icons.send,
            color: Colors.orange[600],
          ),
          textColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: postDetail!.image,
                      height: displayHeight(context) * 0.15,
                      width: displayWidth(context) * 0.28,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Opacity(opacity: 0.0, child: Divider()),
                  Container(
                    child: Text(
                      postDetail.caption,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: displayWidth(context) * 0.035,
                          color: Colors.black87),
                    ),
                  ),
                  const Opacity(opacity: 0.0, child: Divider()),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => usersWhoLikedScreen(
                              usersWhoLiked: postDetail.likes,
                            ),
                          ));
                    },
                    child: Text(
                      '${postDetail.likes.length} likes',
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    height: displayHeight(context) * 0.02,
                    color: Colors.grey[200],
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postId.toString())
                          .collection('comments')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return (snapshot.data.docs.length == 0)
                              ? const Center(
                                  child: Text('No comments'),
                                )
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Timestamp timeStamp = snapshot
                                        .data.docs[index]
                                        .data()['time'];
                                    DateTime commentTime = timeStamp.toDate();
                                    String comment = snapshot.data.docs[index]
                                        .data()['comment'];
                                    List<dynamic> replies = snapshot
                                            .data.docs[index]
                                            .data()['replies'] ??
                                        [];
                                    List<dynamic> likes = snapshot
                                            .data.docs[index]
                                            .data()['likes'] ??
                                        [];
                                    String uid =
                                        snapshot.data.docs[index].data()['uid'];
                                    String commentId = snapshot.data.docs[index]
                                            .data()['commentId'] ??
                                        '';
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: InkWell(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                //content: Text('Are you sure you want to sign-out ?'),
                                                title: const Text('Report comment ?'),
                                                actions: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: TextButton(
                                                          child: const Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color: Colors.black87),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(context);
                                                            showModalBottomSheet(context: context, builder: (context){
                                                              return reportContainerForComment(
                                                                myUid: myProfile.uid,
                                                                postId: postDetail.post_id,
                                                                commentId: commentId,
                                                              );
                                                            });
                                                          },

                                                          child: const Text('Yes',
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black87)),
                                                        )),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: DisplayCommentBox(
                                          uid: uid,
                                          commentTime: commentTime,
                                          replies: replies,
                                          likes: likes,
                                          comment: comment,
                                          commentId: commentId,
                                          postId: widget.postId!,
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.data.docs.length,
                                );
                        } else {
                          return const Center(
                            child: Text('No comments'),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
