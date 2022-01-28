import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Posts/usersWhoLikedScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class CommentScreenForYourPosts extends StatefulWidget {
  final String? postId;
  final NexusUser? postOwner;
  CommentScreenForYourPosts({this.postId, this.postOwner});

  @override
  State<CommentScreenForYourPosts> createState() =>
      _postDetailForMyPostsState();
}

class _postDetailForMyPostsState extends State<CommentScreenForYourPosts> {
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
    NexusUser? myProfile = Provider.of<usersProvider>(context)
        .fetchAllUsers[currentUser!.uid.toString()];
    PostModel? postDetail =
        Provider.of<usersProvider>(context).fetchSavedPostsMap[widget.postId];

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
          sendButtonMethod: () {
            Provider.of<usersProvider>(context,listen: false).commentOnPost(currentUser!.uid, widget.postOwner!.uid, postDetail!.post_id, commentController!.text.toString());
            setState(() {
              commentController!.clear();
            });
          },
          userImage: myProfile!.dp,
          commentController: commentController,
          labelText: "Your Comment",
          sendWidget: Icon(Icons.send),
          textColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: postDetail!.image,
                      height: displayHeight(context) * 0.15,
                      width: displayWidth(context) * 0.3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Opacity(opacity: 0.0, child: Divider()),
                  Container(
                    child: Text(
                      postDetail.caption,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: displayWidth(context) * 0.036,
                          color: Colors.black87),
                    ),
                  ),
                  const Opacity(opacity: 0.0, child: Divider()),
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
                                    String comment = snapshot.data.docs[index]
                                        .data()['comment'];
                                    String uid =
                                        snapshot.data.docs[index].data()['uid'];
                                    String commentId = snapshot.data.docs[index]
                                        .data()['commentId'];
                                    return displayComment(
                                        context, comment, uid);
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
