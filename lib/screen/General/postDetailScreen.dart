import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class postDetailScreen extends StatefulWidget {
  final String? postId;
  final NexusUser? postOwner;
  postDetailScreen({this.postId, this.postOwner});

  @override
  State<postDetailScreen> createState() => _postDetailScreenState();
}

class _postDetailScreenState extends State<postDetailScreen> {
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
        Provider.of<usersProvider>(context).fetchPostsToDisplay[widget.postId];

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
            if (formKey.currentState!.validate()) {
              FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId.toString())
                  .collection('comments')
                  .doc()
                  .set({
                    'comment' : commentController!.text.toString(),
                    'time' : Timestamp.now(),
                    'uid' : currentUser!.uid.toString()
                  });
              setState(() {
                commentController!.clear();
              });
            }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (widget.postOwner!.dp!='')?ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.postOwner!.dp,
                          height: displayHeight(context) * 0.06,
                          width: displayWidth(context) * 0.12,
                          fit: BoxFit.cover,
                        ),
                      ):Icon(Icons.person,size: displayWidth(context)*0.12,color: Colors.orange[300],),
                      const VerticalDivider(),
                      Text(
                        widget.postOwner!.username,
                        style: TextStyle(
                            fontSize: displayWidth(context) * 0.045,
                            color: Colors.indigoAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Opacity(opacity: 0.0, child: Divider()),
                  Container(
                    child: Text(
                      postDetail!.caption,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: displayWidth(context) * 0.036,
                          color: Colors.black87),
                    ),
                  ),
                  Divider(),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postId.toString())
                          .collection('comments')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String comment =
                                snapshot.data.docs[index].data()['comment'];
                            String uid =
                                snapshot.data.docs[index].data()['uid'];
                            return displayComment(context, comment, uid);
                          },
                          itemCount: snapshot.data.docs.length,
                        );
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
