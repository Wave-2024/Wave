import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class storyViewerScreen extends StatelessWidget {
  final List<dynamic>? views;
  storyViewerScreen({this.views});

  @override
  Widget build(BuildContext context) {
    Map<String, NexusUser> allUsers =
        Provider.of<usersProvider>(context).fetchAllUsers;
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
          child: (views!.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: views!.length,
                    itemBuilder: (context, index) {
                      return displayProfileHeads(
                          context, allUsers[views![index]]!);
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
