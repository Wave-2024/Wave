import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class ReplyCommentScreen extends StatefulWidget {
  String commentId;
  String rootComment;
  String commenterId;
  String postId;
  String myUid;
  List<dynamic> replies;
  ReplyCommentScreen(
      {required this.replies,
      required this.commenterId,
      required this.commentId,
      required this.myUid,
      required this.postId,
      required this.rootComment});

  @override
  State<ReplyCommentScreen> createState() => _ReplyCommentScreenState();
}

class _ReplyCommentScreenState extends State<ReplyCommentScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? replyController;
  @override
  void initState() {
    super.initState();
    replyController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    replyController!.dispose();
  }

  Future<bool> replyToThisComment() async {
    if (formKey.currentState!.validate() &&
        replyController!.text.toString().trim().isNotEmpty) {
      List<dynamic> temp = widget.replies;
      temp.add({
        'reply' : replyController!.text.toString(),
        'uid' : widget.myUid,
      });
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .doc(widget.commentId)
          .update({
        'replies' : temp
      });
      return true;
    }
    return false;
  }

  Future<bool> deleteReply(int index) async {
    try{
      List<dynamic> temp = widget.replies;
      temp.removeAt(index);
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .doc(widget.commentId)
          .update({
        'replies' : temp
      });
    }
    catch(error){
      return false;
    }
     return true;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> allUsers = Provider.of<manager>(context).fetchAllUsers;
    NexusUser? originalCommenter = allUsers[widget.commenterId];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Replies',
          style: TextStyle(color: Colors.black),
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
          sendButtonMethod: ()async{
            FocusManager.instance.primaryFocus?.unfocus();
            bool status = await replyToThisComment();
            if(status){
              setState(() {
                replyController!.clear();
              });
            }

          },
          userImage: allUsers[widget.myUid]!.dp!=''?allUsers[widget.myUid]!.dp:constants().fetchDpUrl,
          commentController: replyController,
          labelText: "Your Reply",
          sendWidget: Icon(
            Icons.send,
            color: Colors.orange[600],
          ),
          textColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10, right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 12.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: (originalCommenter!.dp != '')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: displayHeight(context) * 0.042,
                                  width: displayWidth(context) * 0.078,
                                  fit: BoxFit.cover,
                                  imageUrl: originalCommenter.dp,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                color: Colors.orange[300],
                                size: displayWidth(context) * 0.076,
                              ),
                      ),
                    ),
                    (originalCommenter.followers.length >= 5)
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
                          child: printComment(context,
                              originalCommenter.username, widget.rootComment),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black45,
                height: displayHeight(context) * 0.02,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    NexusUser user = allUsers[widget.replies[index]['uid']];
                    String reply = widget.replies[index]['reply'];
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 12.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: (user.dp != '')
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
                          (originalCommenter.followers.length >= 5)
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
                                child:
                                    printComment(context, user.username, reply),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0.0,
                              child: VerticalDivider(
                                width: displayWidth(context) * 0.01,
                              )),
                          IconButton(onPressed: () {
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
                                              bool status = await deleteReply(index);
                                              if(status){
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted your reply'),duration: Duration(seconds: 3),));
                                              }else{
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not delete reply'),duration: Duration(seconds: 3),));
                                              }
                                              setState(() {

                                              });
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
                          }, icon: const Icon(Icons.delete,),
                          iconSize: displayWidth(context)*0.045,
                          color: Colors.black45,)
                        ],
                      ),
                    );
                  },
                  itemCount: widget.replies.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
