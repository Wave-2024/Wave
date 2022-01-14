import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/ChatRoomModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/inboxScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class chatScreen extends StatefulWidget {
  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  User? currentUser;
  bool init = true;
  bool? loadScreen;

  @override
  void initState() {
    super.initState();
    loadScreen = true;
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      Provider.of<usersProvider>(context)
          .fetchUser(currentUser!.uid.toString())
          .then((value) {
        loadScreen = false;
        init = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    NexusUser? myProfile =
        Provider.of<usersProvider>(context, listen: false).fetchCurrentUser;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.indigo[600],
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child:  Column(
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
                      Divider(
                        height: displayHeight(context) * 0.02,
                      ),
                      Container(
                        height: displayHeight(context) * 0.8,
                        width: displayWidth(context),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50)),
                        ),
                        child: Text('hello')
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
