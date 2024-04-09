import 'package:get/get.dart';
import 'package:wave/view/screens/Authentication/login_screen.dart';
import 'package:wave/view/screens/Authentication/register_screen.dart';
import 'package:wave/view/screens/HomeNavigation/home_navigation_screen.dart';
import 'package:wave/view/screens/SplashScreen/splash_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String splashScreen = '/splash';
  static const String homeNavigationScreen = '/homeNavigationScreen';

  static final List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: registerScreen, page: () => RegisterScreen()),
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: homeNavigationScreen, page: () => HomeNavigationScreen()),
  ];
}
