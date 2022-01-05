import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/services/AuthService.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

class userProfile extends StatefulWidget {
  final String? uid;
  userProfile({this.uid});
  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  bool viewPosts = true;
  bool? loadScreen;
  User? currentUser;
  bool init = true;
  final authservice _auth = authservice(FirebaseAuth.instance);
  @override
  void initState() {
    loadScreen = true;
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (init) {
      Provider.of<usersProvider>(context).fetchUser(widget.uid!).then((value) {
        init = false;
        loadScreen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<usersProvider>(context).fetchCurrentUser;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
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
                                user!.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.05,
                                    letterSpacing: 0.8),
                              )),
                          Positioned(
                              left: displayWidth(context) * 0.02,
                              top: displayHeight(context) * 0.005,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.black54,
                                        size: displayWidth(context) * 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              right: displayWidth(context) * 0.02,
                              top: displayHeight(context) * 0.005,
                              child: IconButton(
                                iconSize: displayWidth(context) * 0.08,
                                icon: const Icon(Icons.settings),
                                onPressed: () async {
                                  print(user.posts[0]['caption']);
                                },
                                color: Colors.white70,
                              )),
                        ],
                      ),
                    ),
                    Text(
                      user.username,
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
                                user.followers.length.toString(),
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
                                user.followings.length.toString(),
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
                    Opacity(
                      opacity: 0.0,
                      child: Divider(
                        height: displayHeight(context) * 0.01,
                      ),
                    ),
                    Container(
                      height: displayHeight(context) * 0.08,
                      width: displayWidth(context),
                      //color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Provider.of<usersProvider>(context, listen: false)
                                  .addFollower(
                                      currentUser!.uid.toString(), user.uid);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.deepOrange,
                                      Colors.deepOrangeAccent,
                                      Colors.orange[600]!,
                                    ]),
                              ),
                              height: displayHeight(context) * 0.065,
                              width: displayWidth(context) * 0.4,
                              child: Center(
                                child: Text(
                                  'Follow',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: displayWidth(context) * 0.045),
                                ),
                              ),
                            ),
                          ),
                          Opacity(opacity: 0.0, child: VerticalDivider()),
                          Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.white70,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.mail_outline,
                                  size: displayWidth(context) * 0.05,
                                  color: Colors.black54,
                                ),
                              ))
                        ],
                      ),
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: Divider(
                        height: displayHeight(context) * 0.025,
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
