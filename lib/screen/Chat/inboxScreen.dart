import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Chat/change_chat_bg.dart';
import 'package:nexus/utils/Encrypt_Message.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class inboxScreen extends StatefulWidget {
  String? chatId;
  String? myId;
  String? yourUid;

  inboxScreen({this.yourUid, this.chatId, this.myId});

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
    Map<String, NexusUser>? allUsers =
        Provider.of<manager>(context, listen: false).fetchAllUsers;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Row(
            children: [
              (allUsers[widget.yourUid]!.dp.isNotEmpty)
                  ? CircleAvatar(
                      radius: displayWidth(context) * 0.042,
                      backgroundImage: NetworkImage(
                        allUsers[widget.yourUid]!.dp,
                      ),
                    )
                  : CircleAvatar(
                      radius: displayWidth(context) * 0.042,
                      child: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
              const Opacity(
                  opacity: 0,
                  child: VerticalDivider(
                    width: 12,
                  )),
              Text(
                allUsers[widget.yourUid]!.username,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: Container(
          //color: Colors.white,
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: displayHeight(context) * 0.777,
                  width: displayWidth(context),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8, left: 2, right: 10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chat-room')
                          .doc(widget.chatId)
                          .collection('chat-room')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return (snapshot.data.docs.length == 0)
                              ? const Center(
                                  child: Text(
                                    'Say Hello to your new friend',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    String encryptedMessage =
                                        snapshot.data.docs[index]['message'];
                                    String uid =
                                        snapshot.data.docs[index]['uid'];
                                    String message = encryptMessage()
                                        .decryptThisMessage(encryptedMessage);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      child: messageContainer(
                                          message,
                                          uid,
                                          allUsers[uid]!.dp,
                                          widget.myId!,
                                          context),
                                    );
                                  },
                                );
                        } else {
                          return Center(
                            child: load(context),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  height: displayHeight(context) * 0.1,
                  width: displayWidth(context),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (allUsers[widget.myId]!.dp != '')
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    allUsers[widget.myId]!.dp),
                                radius: displayWidth(context) * 0.06,
                              )
                            : CircleAvatar(
                                radius: displayWidth(context) * 0.06,
                                backgroundColor: Colors.green[200],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.orange,
                                ),
                              ),
                        Opacity(
                            opacity: 0.0,
                            child: VerticalDivider(
                              width: displayWidth(context) * 0.05,
                            )),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 5,
                            minLines: 1,
                            controller: messageController,
                            decoration: const InputDecoration(
                              hintText: "Message",
                            ),
                          ),
                        ),
                        Opacity(
                            opacity: 0.0,
                            child: VerticalDivider(
                              width: displayWidth(context) * 0.01,
                            )),
                        IconButton(
                            onPressed: () {
                              String normalMessage =
                                  messageController!.text.toString();
                              if (normalMessage.trim().isNotEmpty) {
                                String encryptedMessage = encryptMessage()
                                    .encryptThisMessage(normalMessage);
                                sendMessage(
                                    widget.chatId.toString(),
                                    encryptedMessage,
                                    widget.myId!,
                                    widget.yourUid!);
                                setState(() {
                                  messageController!.clear();
                                });
                              }
                            },
                            color: Colors.orange[600],
                            icon: Icon(Icons.send)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
