import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class inboxScreen extends StatefulWidget {
  String? chatId;
  String? myId;
  String? myDp;
  String? personDp;
  String? personUserName;

  inboxScreen(
      {this.myDp, this.personDp, this.personUserName, this.chatId, this.myId});

  @override
  State<inboxScreen> createState() => _inboxScreenState();
}

class _inboxScreenState extends State<inboxScreen> {
  TextEditingController? messageController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: displayWidth(context) * 0.042,
              backgroundImage: NetworkImage(
                widget.personDp.toString(),
              ),
            ),
            const Opacity(
                opacity: 0,
                child: VerticalDivider(
                  width: 12,
                )),
            Text(
              widget.personUserName!,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
              color: Colors.black54,
              onPressed: () {
                print('will think about it');
              },
              icon: Icon(Icons.info))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: CommentBox(
          backgroundColor: Colors.white,
          formKey: formKey,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              sendMessage(widget.chatId.toString(),
                  messageController!.text.toString(), widget.myId.toString());
              setState(() {
                messageController!.clear();
              });
            }
          },
          userImage: widget.myDp,
          commentController: messageController,
          labelText: "Send message",
          sendWidget: Icon(
            Icons.send,
            color: Colors.deepOrange,
          ),
          textColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 16,right: 16),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(widget.chatId.toString())
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    reverse: true,
                    //physics: NeverScrollableScrollPhysics(),
                    //shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      String message = snapshot.data.docs[index]['message'];
                      String uid = snapshot.data.docs[index]['uid'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0, ),
                        child: messageContainer(
                            message, uid, widget.myId.toString(), context),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('Say Hello to your new friend !!'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
