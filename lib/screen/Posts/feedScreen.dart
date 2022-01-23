import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/General/notificationScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class feedScreen extends StatefulWidget {
  @override
  State<feedScreen> createState() => _feedScreenState();
}

class _feedScreenState extends State<feedScreen> {
  User? currentUser;
  bool? init;
  bool? loadScreen;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  void initState() {
    loadScreen = true;
    init = true;
    currentUser = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (init!) {
      Provider.of<usersProvider>(context)
          .setFeedPosts(currentUser!.uid.toString())
          .then((value) {
        loadScreen = false;
        init = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, PostModel> savedPosts =
        Provider.of<usersProvider>(context).fetchSavedPosts;
    final Map<String, PostModel> feedPosts =
        Provider.of<usersProvider>(context).fetchPostsToDisplay;
    final Map<String, NexusUser> allUsers =
        Provider.of<usersProvider>(context).fetchAllUsers;
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
                  children: [
                    Container(
                      height: displayHeight(context) * 0.07,
                      width: displayWidth(context),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 20, right: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.50),
                              child: Text(
                                "Nexus",
                                style: TextStyle(
                                    color: Colors.orange[600],
                                    fontSize: displayWidth(context) * 0.06,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationScreen(),
                                    ));
                              },
                              child: Badge(
                                  badgeColor: Colors.red[400]!,
                                  badgeContent: Text(
                                    '5',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: displayWidth(context) * 0.03),
                                  ),
                                  child: const Icon(Icons.notifications_none)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Opacity(opacity: 0.0, child: Divider()),
                    Container(
                      //color: Colors.blue,
                      height: displayHeight(context) * 0.81,
                      width: displayWidth(context),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 21.0, right: 21, top: 10),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return feedPosts.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Looks like you are not following anyone',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  : Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: displayPostsForFeed(
                                    context,
                                    feedPosts.values.toList()[index],
                                    allUsers,
                                    currentUser!.uid.toString(),
                                    months,
                                          savedPosts),
                              );
                            },
                            itemCount: feedPosts.length,
                          )),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
