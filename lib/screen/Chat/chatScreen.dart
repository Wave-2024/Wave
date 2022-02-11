import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Chat/inboxScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class chatScreen extends StatefulWidget {
  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, NexusUser>? allUsers =
        Provider.of<manager>(context, listen: false).fetchAllUsers;
    NexusUser? myProfile = allUsers[currentUser!.uid.toString()];
    List<dynamic> myFollowingId = myProfile!.followings;
    displayChatHead(String chatId, String lastSeen, String yourUid) {
      return ListTile(
          isThreeLine: false,
          tileColor: Colors.transparent,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => inboxScreen(
                    chatId: chatId,
                    yourUid: yourUid,
                    myId: currentUser!.uid.toString(),
                  ),
                ));
          },
          title: Text(
            allUsers[yourUid]!.username,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: displayWidth(context) * 0.04),
          ),
          subtitle: Text(
            lastSeen,
            style: const TextStyle(color: Colors.black45),
          ),
          leading: (allUsers[yourUid]!.dp != '')
              ? CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(allUsers[yourUid]!.dp),
                  radius: displayWidth(context) * 0.05,
                )
              : CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: displayWidth(context) * 0.05,
                  child: Icon(
                    Icons.person,
                    size: displayWidth(context) * 0.075,
                    color: Colors.orange[400],
                  ),
                ));
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.indigo[600],
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Inbox',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.1),
                    ),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Divider(
                      height: displayHeight(context) * 0.02,
                    ),
                  ),
                  Container(
                      height: displayHeight(context) * 0.86,
                      width: displayWidth(context),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            topLeft: Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 25.0, left: 16, right: 16, bottom: 35),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc(currentUser!.uid)
                              .collection('mychats')
                              .orderBy('last seen', descending: true)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState.index ==
                                ConnectionState.waiting) {
                              return Center(
                                child: load(context),
                              );
                            } else {
                              if (snapshot.hasData) {
                                return (snapshot.data.docs.length == 0)
                                    ? const Center(
                                        child: Text('No chats found'))
                                    : ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          String uid = snapshot.data.docs[index]
                                              .data()['uid'];
                                          String chatId = snapshot
                                              .data.docs[index]
                                              .data()['chatId'];
                                          String userName =
                                              allUsers[uid]!.username;
                                          String dp = allUsers[uid]!.dp;
                                          Timestamp lastSeen = snapshot
                                              .data.docs[index]
                                              .data()['last seen'];
                                          DateTime lastSeenDate =
                                              lastSeen.toDate();
                                          DateTime currentdate = DateTime.now();
                                          String time = differenceOfTimeForChat(
                                              currentdate, lastSeenDate);
                                          return displayChatHead(
                                            chatId,
                                            time,
                                            uid,
                                          );
                                        },
                                      );
                              } else {
                                return Center(
                                  child: Image.asset('images/chatLoad.gif'),
                                );
                              }
                            }
                          },
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
