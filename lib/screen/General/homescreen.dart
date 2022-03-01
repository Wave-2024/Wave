import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/providers/screenIndexProvider.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Posts/addPostScreen.dart';
import 'package:nexus/screen/Chat/chatScreen.dart';
import 'package:nexus/screen/Posts/feedScreen.dart';
import 'package:nexus/screen/ProfileDetails/myProfile.dart';
import 'package:nexus/screen/General/searchScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

class homescreen extends StatelessWidget {
  final List<dynamic> screens = [
    feedScreen(),
    searchScreen(),
    null,
    chatScreen(),
    profiletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    int screenIndex =
        Provider.of<screenIndexProvider>(context).fetchCurrentIndex;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: displayHeight(context) * 0.075,
        child: BottomNavigationBar(
          iconSize: displayWidth(context) * 0.05,
          onTap: (value) {
            if (value == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addPostScreen(),
                  ));
            } else {
              Provider.of<screenIndexProvider>(context, listen: false)
                  .updateIndex(value);
            }
          },
          elevation: 5,
          currentIndex: screenIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black45,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: displayWidth(context) * 0.034),
          items: [
            BottomNavigationBarItem(
                icon:
                    Icon((screenIndex == 0) ? Icons.home : Icons.home_outlined),
                label: "Home",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                    (screenIndex == 1) ? Icons.search : Icons.search_outlined),
                label: "Search",
                backgroundColor: Colors.white),
            const BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "New",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon:
                    Icon((screenIndex == 3) ? Icons.mail : Icons.mail_outline),
                label: "Inbox",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                    (screenIndex == 4) ? Icons.person : Icons.person_outline),
                label: "Profile",
                backgroundColor: Colors.white)
          ],
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: screens[screenIndex],
      ),
    );
  }
}
