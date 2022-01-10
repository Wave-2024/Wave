import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';
class editProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Edit Profile',style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: displayHeight(context)*0.15,
                  width: displayHeight(context)*0.15,
                  color: Colors.orange,
                ),
               const Opacity(opacity: 0.0,child: Divider()),
               const Text('Profile Photo',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w700),),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: TextStyle(color: Colors.black54)
                  ),
                )
              ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
