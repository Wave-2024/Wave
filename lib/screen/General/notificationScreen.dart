import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';
class NotificationScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: Center(
          child: Text('Under development',style: const TextStyle(
            color: Colors.black87,
          ),),
        ),
      ),
    );
  }
}
