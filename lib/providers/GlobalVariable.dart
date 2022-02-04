import 'package:flutter/material.dart';

class GlobalVariable extends ChangeNotifier{
  bool alreadySetUsers = false;
  void updateGlobalVariable(){
    alreadySetUsers = true;
    notifyListeners();
  }
  bool get fetchValue{
    return alreadySetUsers;
}
}