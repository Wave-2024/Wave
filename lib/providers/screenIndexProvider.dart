import 'package:flutter/material.dart';

class screenIndexProvider extends ChangeNotifier {
  int currentIndex = 0;
  void updateIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }

  int get fetchCurrentIndex {
    return currentIndex;
  }
}
