import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/utils/constants.dart';
import 'package:wave/utils/keys.dart';

class HomeNavigationScreen extends StatelessWidget {
  const HomeNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double bottomNavBarItemHeight = 25;
    return Scaffold(
      backgroundColor: primaryScrBG,
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
                        exploreIcon,
                        key: const Key(Keys.keyForExploreIcon),
                        color: (homeNavController.currentScreenIndex == 0)
                            ? primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        searchIcon,
                        key: const Key(Keys.keyForSearchIcon),
                        color: (homeNavController.currentScreenIndex == 1)
                            ? primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        addPostIcon,
                        key: const Key(Keys.keyForAddPostIcon),
                        color: (homeNavController.currentScreenIndex == 2)
                            ? primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        chatIcon,
                        key: const Key(Keys.keyForChatIcon),
                        color: (homeNavController.currentScreenIndex == 3)
                            ? primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        profileIcon,
                        key: const Key(Keys.keyForProfileIcon),
                        color: (homeNavController.currentScreenIndex == 4)
                            ? primaryColor
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
