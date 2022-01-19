import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class viewPostsFromProfile extends StatefulWidget {
  final String? uid;
  viewPostsFromProfile({this.uid});

  @override
  State<viewPostsFromProfile> createState() => _viewPostsFromProfileState();
}

class _viewPostsFromProfileState extends State<viewPostsFromProfile> {
  User? currentUser;
  bool? init;
  bool? screenLoading;
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
    init = true;
    screenLoading = true;
    currentUser = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (init!) {
      Provider.of<usersProvider>(context)
          .setPostsForThisProfile(widget.uid.toString())
          .then((value) {
        init = false;
        screenLoading = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, PostModel> postsForThisUser =
        Provider.of<usersProvider>(context).fetchThisUserPosts;
    final Map<String, NexusUser> allUsers =
        Provider.of<usersProvider>(context).fetchAllUsers;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: (screenLoading!)
            ? Center(
                child: load(context),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 21.0, right: 21, top: 10),
                child: ListView.builder(
                  //physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: displayPostsForThisUser(
                          context,
                          postsForThisUser.values.toList()[index],
                          allUsers,
                          currentUser!.uid.toString(),
                          months),
                    );
                  },
                  itemCount: postsForThisUser.length,
                )),
      ),
    );
  }
}
