// Color Constants

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wave/view/screens/ChatScreen/chat_list_screen.dart';
import 'package:wave/view/screens/CreatePostScreen/create_post_screen.dart';
import 'package:wave/view/screens/ExploreScreen/explore_screen.dart';
import 'package:wave/view/screens/ProfileScreen/profile_screen.dart';
import 'package:wave/view/screens/SearchScreen/search_screen.dart';

final Color primaryColor = Color(0xfbA40606);
final Color primaryGradient1 = Color(0xfbFF4433);
final Color primaryGradient2 = Color(0xfbE30B5C);
final Color authTextBoxColor = Color(0xfbFAFAFBFF);
final Color authTextBoxBorderColor = Colors.blueGrey;
final Color primaryButtonColor = Color(0xfbFFBF00);
final Color errorColor = Colors.red.shade500;
final Color primaryScrBG = Color(0xfbF8F9FAFF);

// Font Constants

final String poppins = "Poppins";

// Image Constants

final String primaryLogo = "assets/logo/primaryLogo.png";
final String logo = "assets/logo/logo.png";

// Icons constants

final String exploreIcon = "assets/icons/explore_ico.png";
final String searchIcon = "assets/icons/search_ico.png";
final String chatIcon = "assets/icons/chat_ico.png";
final String profileIcon = "assets/icons/profile_ico.png";
final String addPostIcon = "assets/icons/add_ico.png";

// DB constants

var database = FirebaseFirestore.instance.collection("users");

// List Of Screens

final List<dynamic> screens = [
  ExploreScreen(),
  SearchScreen(),
  CreatePostScreen(),
  ChatListScreen(),
  ProfileScreen()
];
