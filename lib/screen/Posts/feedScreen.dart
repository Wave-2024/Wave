import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/General/notificationScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

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
                            top: 8.0, bottom: 8.0, left: 20, right: 12),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationScreen(),
                                          ));
                                    },
                                    icon: const Icon(
                                        Icons.notification_add_outlined)),
                              ],
                            )
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
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: displayPostsForFeed(
                                    context,
                                    feedPosts.values.toList()[index],
                                    allUsers,
                                    currentUser!.uid.toString(),
                                    months,
                                  savedPosts
                                ),
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
