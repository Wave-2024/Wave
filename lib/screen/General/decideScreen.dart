import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/screen/Authentication/verifyEmailScreen.dart';
import 'package:nexus/screen/General/WelcomeScreen.dart';

class decideScreen extends StatefulWidget {
  @override
  _decideScreenState createState() => _decideScreenState();
}

class _decideScreenState extends State<decideScreen> {
  User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser!.emailVerified) {
      return welcomeScreen();
    } else {
      return verifyEmailScreen();
    }
  }
}
