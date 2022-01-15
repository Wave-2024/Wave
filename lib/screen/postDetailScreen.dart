import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/CommentModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class postDetailScreen extends StatefulWidget {
  final String? postId;
  final NexusUser? user_who_posted;
  postDetailScreen({this.postId, this.user_who_posted});

  @override
  State<postDetailScreen> createState() => _postDetailScreenState();
}

class _postDetailScreenState extends State<postDetailScreen> {
  User? currentUser;
  TextEditingController? commentController;
  final formKey = GlobalKey<FormState>();
  bool init = true;
  bool? loadingScreen;
  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    commentController = TextEditingController();
    loadingScreen = true;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      await Provider.of<usersProvider>(context)
          .setCommentsForThisPost(widget.postId!);

      Provider.of<usersProvider>(context, listen: false)
          .fetchUser(currentUser!.uid.toString())
          .then((value) {
        loadingScreen = false;
        init = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    commentController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostModel? postDetail = Provider.of<usersProvider>(context)
        .fetchThisPostDetails(widget.postId!);
    NexusUser? myProfile = Provider.of<usersProvider>(context).fetchCurrentUser;

    List<CommentModel> comments =
        Provider.of<usersProvider>(context).fetchCommentsForThisPost;
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
        child: (loadingScreen!)
            ? load(context)
            : CommentBox(
                backgroundColor: Colors.white,
                formKey: formKey,
                errorText: 'Comment cannot be blank',
                sendButtonMethod: () {
                  if (formKey.currentState!.validate()) {
                    Provider.of<usersProvider>(context, listen: false)
                        .addCommentToThisPost(
                            myProfile!.dp,
                            myProfile.username,
                            commentController!.text.toString(),
                            currentUser!.uid,
                            postDetail!.post_id)
                        .then((value) {
                      setState(() {
                        commentController!.clear();
                      });
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: widget.user_who_posted!.dp,
                                height: displayHeight(context) * 0.06,
                                width: displayWidth(context) * 0.12,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const VerticalDivider(),
                            Text(
                              widget.user_who_posted!.username,
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
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return displayComment(context, comments[index]);
                          },
                          itemCount: comments.length,
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
