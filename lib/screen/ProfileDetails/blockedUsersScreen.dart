import 'package:flutter/material.dart';
class blockedUsersScreen extends StatelessWidget {
  const blockedUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Blocked Users',style: TextStyle(color: Colors.black87),),iconTheme: const IconThemeData(
        color: Colors.black87,
      ),),
    );
  }
}
