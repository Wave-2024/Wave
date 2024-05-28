import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/keys.dart';
import 'package:wave/utils/constants/preferences.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/screens/ChatScreen/chat_list_screen.dart';
import 'package:wave/view/screens/CreatePostScreen/create_post_screen.dart';
import 'package:wave/view/screens/FeedScreen/feed_screen.dart';
import 'package:wave/view/screens/ProfileScreen/profile_screen.dart';
import 'package:wave/view/screens/SearchScreen/search_screen.dart';

class HomeNavigationScreen extends StatefulWidget {
  HomeNavigationScreen({super.key});

  @override
  State<HomeNavigationScreen> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  final List<dynamic> screens = [
    const FeedScreen(),
    const SearchScreen(),
    CreatePostScreen(),
    const ChatListScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();

    // Request permission for notifications
    var res = FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get the token for this device
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
      // You can save the token to your database here
    });

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground: ${message.messageId}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Show a dialog or update the UI based on the message
      }
    });

    // Handle messages when the app is opened from a terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from a terminated state: ${message.messageId}');
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }
    });

    // Handle messages when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    checkNotificationSettings();
  }

  Future<void> checkNotificationSettings() async {
    // less than 33 mean android 10,11,12
    bool isCurrentlyGettingNotification =
        await Permission.notification.isGranted;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (!isCurrentlyGettingNotification) {
      bool alreadyAsked =
          preferences.getBool(Pref.alreadyAskedForNotification) ?? false;
      if (!alreadyAsked) {
        
        if (mounted) {
          preferences.setBool(Pref.alreadyAskedForNotification, true);
          showNotificationPermissionDialog(context);
        }
      }
    }
  }

  Future<int> checkAndroidVersion() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      int sdkInt = androidInfo.version.sdkInt;
      return sdkInt; // SDK 33 corresponds to Android 13
    } catch (e) {
      return -1;
    }
  }

  void showNotificationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Allow Notifications'),
          content: const Text(
            'To receive important notifications, please allow notifications in the settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                requestNotificationPermission();
              },
              child: const Text('Allow Notifications'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    double bottomNavBarItemHeight = 25;
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      bottomNavigationBar: Consumer<HomeNavController>(
        builder: (context, homeNavController, child) {
          return BottomNavigationBar(
              key: const Key(Keys.keyForBottomNavButton),
              onTap: (newScreenIndex) {
                if (newScreenIndex == 2) {
                  Get.toNamed(AppRoutes.createNewPostScreen);
                } else {
                  Get.printInfo(info: "Selected $newScreenIndex index");
                  homeNavController.setCurrentScreenIndex(newScreenIndex);
                }
              },
              elevation: 0,
              currentIndex: homeNavController.currentScreenIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              showUnselectedLabels: false,
              selectedItemColor: CustomColor.primaryColor,
              showSelectedLabels: true,
              selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomFont.poppins,
                  letterSpacing: -0.1,
                  fontSize: 10.5),
              // iconSize: 25,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset(
                      (homeNavController.currentScreenIndex == 0)
                          ? CustomIcon.exploreFullIcon
                          : CustomIcon.exploreIcon,
                      key: const Key(Keys.keyForExploreIcon),
                      color: (homeNavController.currentScreenIndex == 0)
                          ? CustomColor.primaryColor
                          : null,
                      height: bottomNavBarItemHeight,
                    ),
                  ),
                  label: "Explore",
                ),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        (homeNavController.currentScreenIndex == 1)
                            ? CustomIcon.searchFullIcon
                            : CustomIcon.searchIcon,
                        key: const Key(Keys.keyForSearchIcon),
                        color: (homeNavController.currentScreenIndex == 1)
                            ? CustomColor.primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: "Search"),
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
                    label: "New"),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        (homeNavController.currentScreenIndex == 3)
                            ? CustomIcon.chatFullIcon
                            : CustomIcon.chatIcon,
                        key: const Key(Keys.keyForChatIcon),
                        color: (homeNavController.currentScreenIndex == 3)
                            ? CustomColor.primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: "Chat"),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        (homeNavController.currentScreenIndex == 4)
                            ? CustomIcon.profileFullIcon
                            : CustomIcon.profileIcon,
                        key: const Key(Keys.keyForProfileIcon),
                        color: (homeNavController.currentScreenIndex == 4)
                            ? CustomColor.primaryColor
                            : null,
                        height: bottomNavBarItemHeight,
                      ),
                    ),
                    label: "Profile")
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
