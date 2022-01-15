import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/providers/screenIndexProvider.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/addPostScreen.dart';
import 'package:nexus/screen/chatScreen.dart';
import 'package:nexus/screen/feedScreen.dart';
import 'package:nexus/screen/profileScreen.dart';
import 'package:nexus/screen/searchScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

class homescreen extends StatelessWidget {
  final List<dynamic> screens = [
    feedScreen(),
    searchScreen(),
    chatScreen(),
    profiletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    int screenIndex =
        Provider.of<screenIndexProvider>(context).fetchCurrentIndex;
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: displayHeight(context),
              width: displayWidth(context),
              //color: Colors.white70,
              child: screens[screenIndex],
            ),
            Positioned(
                bottom: displayHeight(context) * 0.015,
                child: Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                    ),
                    height: displayHeight(context) * 0.075,
                    width: displayWidth(context) * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: (screenIndex == 0)
                                ? CircleAvatar(
                                    radius: displayWidth(context) * 0.052,
                                    backgroundColor: Colors.orange[600],
                                    child: const Icon(
                                      Icons.home,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    iconSize: displayWidth(context) * 0.06,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.home_outlined),
                                    onPressed: () {
                                      Provider.of<screenIndexProvider>(context,
                                              listen: false)
                                          .updateIndex(0);
                                    },
                                  )),
                        Expanded(
                            child: (screenIndex == 1)
                                ? CircleAvatar(
                                    radius: displayWidth(context) * 0.052,
                                    backgroundColor: Colors.orange[600],
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    iconSize: displayWidth(context) * 0.06,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.search),
                                    onPressed: () {
                                      Provider.of<screenIndexProvider>(context,
                                              listen: false)
                                          .updateIndex(1);
                                    },
                                  )),
                        Expanded(
                            child: IconButton(
                          iconSize: displayWidth(context) * 0.06,
                          color: Colors.black54,
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => addPostScreen(),
                                ));
                          },
                        )),
                        Expanded(
                            child: (screenIndex == 2)
                                ? CircleAvatar(
                                    radius: displayWidth(context) * 0.052,
                                    backgroundColor: Colors.orange[600],
                                    child: const Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    iconSize: displayWidth(context) * 0.06,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.mail),
                                    onPressed: () {
                                      Provider.of<screenIndexProvider>(context,
                                              listen: false)
                                          .updateIndex(2);
                                    },
                                  )),
                        Expanded(
                            child: (screenIndex == 3)
                                ? CircleAvatar(
                                    radius: displayWidth(context) * 0.052,
                                    backgroundColor: Colors.orange[600],
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    iconSize: displayWidth(context) * 0.06,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.person_outlined),
                                    onPressed: () {
                                      Provider.of<screenIndexProvider>(context,
                                              listen: false)
                                          .updateIndex(3);
                                    },
                                  )),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
