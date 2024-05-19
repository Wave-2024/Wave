import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/route_manager.dart';
import 'package:wave/controllers/Authentication/auth_screen_controller.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/controllers/PostController/create_post_controller.dart';
import 'package:wave/controllers/PostController/feed_post_controller.dart';
import 'package:wave/utils/routing.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Wave());
}

class Wave extends StatelessWidget {
  const Wave({super.key});

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
      child: GetMaterialApp(
        getPages: AppRoutes.routes,
        initialRoute: AppRoutes.splashScreen,
      ),
    );
  }
}
