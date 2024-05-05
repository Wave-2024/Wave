import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/keys.dart';
import 'package:wave/view/screens/ChatScreen/chat_list_screen.dart';
import 'package:wave/view/screens/CreatePostScreen/create_post_screen.dart';
import 'package:wave/view/screens/ExploreScreen/explore_screen.dart';
import 'package:wave/view/screens/ProfileScreen/profile_screen.dart';
import 'package:wave/view/screens/SearchScreen/search_screen.dart';

class HomeNavigationScreen extends StatelessWidget {
  HomeNavigationScreen({super.key});

  final List<dynamic> screens = [
    ExploreScreen(),
    SearchScreen(),
    CreatePostScreen(),
    ChatListScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    double bottomNavBarItemHeight = 25;
    return Scaffold(
      backgroundColor: CustomColor.primaryScrBG,
      bottomNavigationBar: Consumer<HomeNavController>(
        builder: (context, homeNavController, child) {
          return BottomNavigationBar(
              key: Key(Keys.keyForBottomNavButton),
              onTap: (newScreenIndex) {
                Get.printInfo(info: "Selected ${newScreenIndex} index");
                homeNavController.setCurrentScreenIndex(newScreenIndex);
              },
              elevation: 0,
              currentIndex: homeNavController.currentScreenIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              // iconSize: 25,
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        CustomIcon.exploreIcon,
                        key: const Key(Keys.keyForExploreIcon),
                        color: (homeNavController.currentScreenIndex == 0)
                            ? CustomColor.primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        CustomIcon.searchIcon,
                        key: const Key(Keys.keyForSearchIcon),
                        color: (homeNavController.currentScreenIndex == 1)
                            ? CustomColor.primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        CustomIcon.addPostIcon,
                        key: const Key(Keys.keyForAddPostIcon),
                        color: (homeNavController.currentScreenIndex == 2)
                            ? CustomColor.primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        CustomIcon.chatIcon,
                        key: const Key(Keys.keyForChatIcon),
                        color: (homeNavController.currentScreenIndex == 3)
                            ? CustomColor.primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        CustomIcon.profileIcon,
                        key: const Key(Keys.keyForProfileIcon),
                        color: (homeNavController.currentScreenIndex == 4)
                            ? CustomColor.primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: "")
              ]);
        },
      ),
      body: Consumer<HomeNavController>(
        builder: (context, homeNavController, child) {
          return screens[homeNavController.currentScreenIndex];
        },
      ),
    );
  }
}
