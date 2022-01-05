import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/services/AuthService.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/firebaseServices.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class profiletScreen extends StatefulWidget {
  @override
  State<profiletScreen> createState() => _profiletScreenState();
}

class _profiletScreenState extends State<profiletScreen> {
  bool viewPosts = true;
  bool? loadScreen;
  User? currentUser;
  bool init = true;
  final authservice _auth = authservice(FirebaseAuth.instance);
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    loadScreen = true;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (init) {
      Provider.of<usersProvider>(context)
          .fetchUser(currentUser!.uid)
          .then((value) {
        loadScreen = false;
        init = false;
      });
    }
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
          color: Colors.white,
          child: (loadScreen!)
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                    backgroundColor: Colors.blue,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: displayHeight(context) * 0.295,
                      width: displayWidth(context),
                      //color: Colors.pink,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            top: 0,
                            child: Image.asset(
                              'images/cover.jpg',
                              height: displayHeight(context) * 0.2,
                              width: displayWidth(context),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: displayWidth(context),
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.white],
                                    stops: [0, .7])),
                          ),
                          Positioned(
                              top: displayHeight(context) * 0.16,
                              child: Container(
                                height: displayHeight(context) * 0.1,
                                width: displayWidth(context) * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                      color: Colors.orangeAccent, width: 2.3),
                                ),
                              )),
                          Positioned(
                              top: displayHeight(context) * 0.1655,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  'images/male.jpg',
                                  height: displayHeight(context) * 0.0905,
                                  width: displayWidth(context) * 0.175,
                                ),
                              )),
                          Positioned(
                              top: displayHeight(context) * 0.02,
                              child: Text(
                                myProfile!.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.05,
                                    letterSpacing: 0.8),
                              )),
                          Positioned(
                              right: displayWidth(context) * 0.02,
                              top: displayHeight(context) * 0.005,
                              child: IconButton(
                                iconSize: displayWidth(context) * 0.08,
                                icon: const Icon(Icons.settings),
                                onPressed: () async {
                                  print(myProfile.posts[0]['caption']);
                                },
                                color: Colors.white70,
                              )),
                        ],
                      ),
                    ),
                    Text(
                      myProfile.username,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: displayWidth(context) * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                    const Opacity(
                      opacity: 0.0,
                      child: Divider(
                        height: 2,
                      ),
                    ),
                    Container(
                      height: displayHeight(context) * 0.1,
                      width: displayWidth(context),
                      //color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                myProfile.followers.length.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.04),
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: displayWidth(context) * 0.036),
                              )
                            ],
                          )),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                myProfile.followings.length.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.04),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: displayWidth(context) * 0.036),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '18',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.04),
                              ),
                              Text(
                                'Posts',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: displayWidth(context) * 0.036),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                    const Opacity(
                      opacity: 0.0,
                      child: Divider(
                        height: 2,
                      ),
                    ),
                    Container(
                      height: displayHeight(context) * 0.08,
                      width: displayWidth(context) * 0.62,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (!viewPosts) {
                                    viewPosts = !viewPosts;
                                  }
                                });
                              },
                              child: (viewPosts)
                                  ? Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 45.0,
                                              right: 45,
                                              top: 8,
                                              bottom: 8),
                                          child: Text(
                                            'Posts',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                    displayWidth(context) *
                                                        0.042,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Posts',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize:
                                              displayWidth(context) * 0.042,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (viewPosts) {
                                    viewPosts = !viewPosts;
                                  }
                                });
                              },
                              child: (!viewPosts)
                                  ? Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 45.0,
                                              right: 45,
                                              top: 8,
                                              bottom: 8),
                                          child: Text(
                                            'Saved',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                    displayWidth(context) *
                                                        0.042,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Saved',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize:
                                              displayWidth(context) * 0.042,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
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
}
