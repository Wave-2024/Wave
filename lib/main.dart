import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wave/controllers/Authentication/auth_screen_controller.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/controllers/PostController/create_post_controller.dart';
import 'package:wave/controllers/PostController/feed_post_controller.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/utils/routing.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  "Handling a background message: ${message.messageId}".printInfo();
  if (message.notification != null) {
    'Message also contained a notification: ${message.notification}'
        .printError();
  }
}

void handleNotificationClick(Map<String, dynamic> messageData) async {
  if (messageData.containsKey('chatId') &&
      messageData.containsKey('otherUserId')) {
    User otherUser = await UserData.getUser(userID: messageData['otherUserId']);
    User selfUser = await UserData.getUser(userID: messageData['selfUserId']);
    Get.toNamed(AppRoutes.inboxScreen, arguments: {
      'chatId': messageData['chatId'],
      'otherUser': otherUser,
      'selfUser': selfUser,
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    handleNotificationClick(message.data);
  });
  runApp(Wave(
    initialMessage: initialMessage,
  ));
}

class Wave extends StatelessWidget {
  final RemoteMessage? initialMessage;
  const Wave({Key? key, this.initialMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserDataController(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeNavController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CreatePostController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FeedPostController(),
        ),
      ],
      builder: (context, child) {
        if (initialMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            handleNotificationClick(initialMessage!.data);
          });
        } else {}
        return child!;
      },
      child: GetMaterialApp(
        getPages: AppRoutes.routes,
        initialRoute: AppRoutes.splashScreen,
      ),
    );
  }
}
