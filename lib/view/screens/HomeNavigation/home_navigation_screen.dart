import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/utils/constants.dart';

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
                onTap: (newScreenIndex) {
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
                          color: (homeNavController.currentScreenIndex == 4)
                              ? primaryColor
                              : null,
                          height: bottomNavBarItemHeight,
                        ),
                      ),
                      label: "")
                ]);
          },
        ));
  }
}
