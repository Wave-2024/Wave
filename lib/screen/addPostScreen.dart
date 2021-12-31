import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';
class addPostScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.indigo[200],
        ),
      ),
    );
  }
}