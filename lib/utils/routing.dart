import 'package:get/get.dart';
import 'package:wave/view/screens/Authentication/login_screen.dart';


class AppRoutes {
  static const String loginScreen = '/';

  static final List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => LoginScreen()),
  ];
}
