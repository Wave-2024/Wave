import 'package:flutter/material.dart';
import 'package:nexus/providers/screenIndexProvider.dart';
import 'package:nexus/screen/Chat/chatScreen.dart';
import 'package:nexus/screen/Posts/feedScreen.dart';
import 'package:nexus/screen/Posts/newPost/VideoPost.dart';
import 'package:nexus/screen/Posts/newPost/imagePost.dart';
import 'package:nexus/screen/Posts/newPost/textPost.dart';
import 'package:nexus/screen/ProfileDetails/myProfile.dart';
import 'package:nexus/screen/General/searchScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

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
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -2),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextPost(),
                                      ));
                                },
                                title: const Text('New Text Post'),
                              ),
                              ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -2),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => imagePost(),
                                      ));
                                },
                                title: const Text('New Image post'),
                              ),
                              ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -2),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPost(),
                                      ));
                                },
                                title: const Text('New Video post'),
                              ),
                              ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                onTap: () {
                                  Navigator.pop(ctx);
                                },
                                textColor: Colors.red,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    Opacity(
                                      opacity: 0.0,
                                      child: VerticalDivider(),
                                    ),
                                    Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                Provider.of<screenIndexProvider>(context, listen: false)
                    .updateIndex(value);
              }
            },
            elevation: 8,
            currentIndex: screenIndex,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.black45,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: displayWidth(context) * 0.034),
            items: [
              BottomNavigationBarItem(
                icon:
                    Icon((screenIndex == 0) ? Icons.home : Icons.home_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    (screenIndex == 1) ? Icons.search : Icons.search_outlined),
                label: "Search",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "New",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                      (screenIndex == 3) ? Icons.mail : Icons.mail_outline),
                  label: "Inbox",
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                icon: Icon(
                    (screenIndex == 4) ? Icons.person : Icons.person_outline),
                label: "Profile",
              )
            ],
          ),
        ),
        body: IndexedStack(
          index: screenIndex,
          children: [
            feedScreen(),
            searchScreen(),
            searchScreen(), // will never be used
            chatScreen(),
            profiletScreen(),
          ],
        ));
  }
}
