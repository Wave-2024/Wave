import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:nexus/screen/Chat/change_chat_bg.dart';
import 'package:nexus/utils/Encrypt_Message.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';

class inboxScreen extends StatefulWidget {
  String? chatId;
  String? myId;
  String? myDp;
  String? personDp;
  String? personUserName;
  int? indexForBackground;

  inboxScreen(
      {this.myDp,
      this.indexForBackground,
      this.personDp,
      this.personUserName,
      this.chatId,
      this.myId});

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
        iconTheme: const IconThemeData(
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
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
              color: Colors.black54,
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                return Container(
                  height: displayHeight(context)*0.14,
                  width: displayWidth(context),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap : (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => changeChatBG(),));
                },
                        child: Text('Change background image',style: TextStyle(
                          color: Colors.orange[600],fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context)*0.047,
                        ),),
                      ),
                      const Opacity(opacity: 0,child: Divider(color: Colors.black87,)),
                      Text('Block user',style: TextStyle(
                          color: Colors.orange[600],fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context)*0.047,
                      ),),
                    ],
                  ),
                );
                },);
              },
              icon: Icon(Icons.info))
        ],
      ),
      body: Container(
        //color: Colors.white,
        height: displayHeight(context),
        width: displayWidth(context),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/chat_bg6.jpg'), fit: BoxFit.cover)),
        child: CommentBox(
          backgroundColor: Colors.white,
          formKey: formKey,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              String normalMessage = messageController!.text.toString();

              String encryptedMessage =
                  encryptMessage().encryptThisMessage(normalMessage);

              sendMessage(widget.chatId.toString(), encryptedMessage,
                  widget.myId.toString());
              setState(() {
                messageController!.clear();
              });
            }
          },
          userImage: widget.myDp,
          commentController: messageController,
          labelText: "Send message",
          sendWidget: const Icon(
            Icons.send,
            color: Colors.deepOrange,
          ),
          textColor: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 8, left: 2, right: 10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(widget.chatId.toString())
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      String encryptedMessage =
                          snapshot.data.docs[index]['message'];
                      String uid = snapshot.data.docs[index]['uid'];
                      String message =
                          encryptMessage().decryptThisMessage(encryptedMessage);
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: messageContainer(
                            message,
                            uid,
                            widget.personDp.toString(),
                            widget.myId.toString(),
                            context),
                      );
                    },
                  );
                } else {
                  return const Center(
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
