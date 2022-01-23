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
        Provider.of<usersProvider>(context, listen: false).fetchAllUsers;
    NexusUser? myProfile = allUsers[currentUser!.uid.toString()];
    displayChatHead(String chatId, String username, String dp, int chatbg,
        String lastSeen) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => inboxScreen(
                  chatId: chatId,
                  personDp: dp,
                  chatbg: chatbg,
                  personUserName: username,
                  myDp: myProfile!.dp,
                  myId: currentUser!.uid.toString(),
                ),
              ));
        },
        child: Container(
          //color: Colors.redAccent,
          height: displayHeight(context) * 0.1,
          width: displayWidth(context),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 12.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: (dp != '')
                          ? CachedNetworkImage(
                              height: displayHeight(context) * 0.06,
                              width: displayWidth(context) * 0.12,
                              fit: BoxFit.cover,
                              imageUrl: dp,
                            )
                          : Image.asset(
                              'images/male.jpg',
                              height: displayHeight(context) * 0.06,
                              width: displayWidth(context) * 0.12,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const Opacity(opacity: 0.0, child: VerticalDivider()),
                Container(
                  height: displayHeight(context) * 0.06,
                  width: displayWidth(context) * 0.68,
                  //color: Colors.purple,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: displayWidth(context) * 0.04),
                      ),
                      Text(
                        lastSeen,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: displayWidth(context) * 0.036),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
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
                      'Chat\'s',
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
                              .collection(currentUser!.uid.toString())
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  String uid =
                                      snapshot.data.docs[index].data()['uid'];
                                  String chatId = snapshot.data.docs[index]
                                      .data()['chatId'];
                                  String userName = allUsers[uid]!.username;
                                  String dp = allUsers[uid]!.dp;
                                  Timestamp lastSeen = snapshot.data.docs[index]
                                      .data()['lastSent'];
                                  DateTime currentDate = DateTime.now();
                                  DateTime lastSeenDate = lastSeen.toDate();
                                  int chatbg = snapshot.data.docs[index]
                                      .data()['chatbg'];
                                  return displayChatHead(
                                      chatId,
                                      userName,
                                      dp,
                                      chatbg,
                                      differenceOfTime(
                                          currentDate, lastSeenDate));
                                },
                              );
                            } else {
                              return Center(child: Text('No Chats Found'));
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
