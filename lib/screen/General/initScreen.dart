import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/General/homescreen.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class welcomeScreen extends StatefulWidget {
  @override
  _welcomeScreenState createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  bool init = true;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      await Provider.of<usersProvider>(context).setAllUsers();
      await Provider.of<usersProvider>(context, listen: false)
          .setSavedPostsOnce(currentUser!.uid.toString());
      init = false;
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => homescreen(),
            ));
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            load(context),
            Opacity(opacity: 0, child: Divider()),
            Text('Please wait while we setup the screen for you !!')
          ],
        ),
      ),
    );
  }
}
