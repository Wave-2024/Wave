import 'package:get/get.dart';
import 'package:wave/view/reusable_components/view_image.dart';
import 'package:wave/view/screens/Authentication/login_screen.dart';
import 'package:wave/view/screens/Authentication/register_screen.dart';
import 'package:wave/view/screens/ChatScreen/inbox_screen.dart';
import 'package:wave/view/screens/ChatScreen/search_to_chat.dart';
import 'package:wave/view/screens/CreatePostScreen/create_post_screen.dart';
import 'package:wave/view/screens/CreatePostScreen/post_detail_screen.dart';
import 'package:wave/view/screens/CreatePostScreen/search_to_mention.dart';
import 'package:wave/view/screens/FeedScreen/list_comment_screen.dart';
import 'package:wave/view/screens/HomeNavigation/home_navigation_screen.dart';
import 'package:wave/view/screens/NotificationScreen/notification_screen.dart';
import 'package:wave/view/screens/ProfileScreen/blocked_contacts_screen.dart';
import 'package:wave/view/screens/ProfileScreen/edit_profile_screen.dart';
import 'package:wave/view/screens/ProfileScreen/list_users.dart';
import 'package:wave/view/screens/ProfileScreen/profile_screen.dart';
import 'package:wave/view/screens/SplashScreen/splash_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String splashScreen = '/splash';
  static const String homeNavigationScreen = '/homeNavigationScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String createNewPostScreen = '/createNewPostScreen';
  static const String searchToMentionScreen = '/searchToMentionScreen';
  static const String profileScreen = '/profileScreen';
  static const String listUsersScreen = '/listUsersScreen';
  static const String listCommentsScreen = '/listCommentsScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String searchToChatScreen = '/searchToChatScreen';
  static const String inboxScreen = '/inboxScreen';
  static const String blockedContactsScreen = '/blockedContacts';
    static const String postDetailScreen = '/postDetailScreen';
  static const String viewImageScreen = '/viewImageScreen';


  

  static final List<GetPage> routes = [
    GetPage(
        name: profileScreen,
        page: () => ProfileScreen(),
        transition: Transition.leftToRight),
    GetPage(
        name: viewImageScreen,
        page: () => ViewImage(),
        transition: Transition.circularReveal),
    GetPage(
        name: listUsersScreen,
        page: () => ListUsers(),
        transition: Transition.leftToRightWithFade),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: registerScreen, page: () => RegisterScreen()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(
        name: searchToMentionScreen,
        page: () => const SearchToMention(),
        transition: Transition.leftToRight),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(
        name: createNewPostScreen,
        page: () => CreatePostScreen(),
        transition: Transition.rightToLeft),
    GetPage(name: homeNavigationScreen, page: () => HomeNavigationScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(
        name: listCommentsScreen,
        page: () => const ListCommentsScreen(),
        transition: Transition.leftToRight),
    GetPage(
        name: inboxScreen,
        page: () => const InboxScreen(),
        transition: Transition.leftToRight),
    GetPage(
        name: notificationScreen,
        page: () => const NotificationScreen(),
        transition: Transition.leftToRight),
                GetPage(name: blockedContactsScreen, page: () => BlockedContacts()),
    GetPage(
        name: searchToChatScreen,
        page: () => const SearchToChat(),
        transition: Transition.rightToLeftWithFade),
        GetPage(
        name: postDetailScreen,
        page: () => PostDetailScreen(),
        transition: Transition.rightToLeftWithFade),
  ];
}
