import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

class blockedUsersScreen extends StatelessWidget {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    List<dynamic> blockedUsersUid = Provider.of<manager>(context, listen: false)
        .fetchAllUsers[currentUser!.uid]!
        .blocked;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Blocked Users',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
      ),
    );
  }
}
