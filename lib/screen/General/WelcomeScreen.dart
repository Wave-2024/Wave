import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/General/homescreen.dart';
import 'package:nexus/utils/devicesize.dart';
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
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      await Provider.of<manager>(context).setAllUsers();
      await Provider.of<manager>(context, listen: false)
          .setFeedPosts(currentUser!.uid);
      await Provider.of<manager>(context, listen: false)
          .setMyPosts(currentUser!.uid.toString());
      await Provider.of<manager>(context, listen: false)
          .setSavedPostsOnce(currentUser!.uid.toString());
      init = false;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => homescreen(),
          ));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/welcome.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: displayHeight(context) * 0.4,
              ),
              Image.asset(
                'images/wave.png',
                width: displayWidth(context) * 0.5,
                fit: BoxFit.cover,
              ),
              const CircularProgressIndicator(
                backgroundColor: Colors.indigo,
                color: Colors.white30,
              ),
              Expanded(
                child: SizedBox(
                  height: displayHeight(context) * 0.3,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Made with ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.04,
                          color: Colors.black),
                    ),
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Text(
                      ' in India',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.04,
                          color: Colors.black),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}