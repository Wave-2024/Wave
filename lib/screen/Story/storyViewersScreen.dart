import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class storyViewerScreen extends StatefulWidget {
  @override
  State<storyViewerScreen> createState() => _storyViewerScreenState();
}

class _storyViewerScreenState extends State<storyViewerScreen> {
  bool? init;
  User? currentUser;
  bool? loading;
  @override
  void initState() {
    init = true;
    currentUser=FirebaseAuth.instance.currentUser;
    loading = true;
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    if(init!){
      await Provider.of<manager>(context).setMyProfile(currentUser!.uid);
      loading = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, NexusUser> allUsers =
        Provider.of<manager>(context).fetchAllUsers;
    List<dynamic> views = allUsers[currentUser!.uid]!.views;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Views',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          child: (loading!)?Center(
            child: load(context),
          ):(views.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: views.length,
                    itemBuilder: (context, index) {
                      return displayProfileHeads(
                          context, allUsers[views[index]]!);
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    'No Views',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
        ));
  }
}
