import 'package:get/get.dart';
import 'package:wave/view/screens/Authentication/login_screen.dart';
import 'package:wave/view/screens/Authentication/register_screen.dart';
import 'package:wave/view/screens/CreatePostScreen/create_post_screen.dart';
import 'package:wave/view/screens/CreatePostScreen/search_to_mention.dart';
import 'package:wave/view/screens/HomeNavigation/home_navigation_screen.dart';
import 'package:wave/view/screens/ProfileScreen/edit_profile_screen.dart';
import 'package:wave/view/screens/SplashScreen/splash_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String splashScreen = '/splash';
  static const String homeNavigationScreen = '/homeNavigationScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String createNewPostScreen = '/createNewPostScreen';
  static const String searchToMentionScreen = '/searchToMentionScreen';

  static final List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: registerScreen, page: () => RegisterScreen()),
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(
        name: searchToMentionScreen,
        page: () => SearchToMention(),
        transition: Transition.leftToRight),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(
        name: createNewPostScreen,
        page: () => CreatePostScreen(),
        transition: Transition.rightToLeft),
    GetPage(name: homeNavigationScreen, page: () => HomeNavigationScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
  ];
}
