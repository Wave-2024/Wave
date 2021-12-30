import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;

class usernameProvider extends ChangeNotifier{
  Map<String,bool>? usernames = {};
  Map<String,bool>? get fetchUserNames{
    return usernames;
  }

  Future<void> setUserNames() async {
    Map<String,bool> temp = {};
    final String api = constants().fetchApi+'users.json';
    try{
      print('reached');
      final response = await http.get(Uri.parse(api));
      print(response.statusCode);
      if (json.decode(response.body) == null) {
        usernames = temp;
        notifyListeners();
        return;
      }
      final data = jsonDecode(response.body) as Map<String,dynamic>;

      data.forEach((key, value) {
        temp[value['username']] = true;
      });

      usernames = temp;
      notifyListeners();
    }
    catch(error){
      print(error);
    }
  }
}