import 'package:flutter/material.dart';

class HomeNavController extends ChangeNotifier {
  int currentScreenIndex = 0;

  void setCurrentScreenIndex(int newIndex) {
    currentScreenIndex = newIndex;
    notifyListeners();
  }
}
