import 'package:flutter/material.dart';
import 'package:nexus/screen/AboutWave/OpenSource.dart';
import 'package:nexus/screen/AboutWave/privacyPolicyScreen.dart';
import 'package:nexus/screen/AboutWave/termsOfUse.dart';
class AboutWaveScreen extends StatelessWidget {
  const AboutWaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('About Wave',style: TextStyle(color: Colors.black87),),iconTheme: const IconThemeData(
        color: Colors.black87,
      ),),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => privacyPolicyScreen(),));
              },
              title: Text('Privacy Policy'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => termsOfUseScreen(),));
              },
              title: Text('Terms of Use'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OpenSourceDetail(),));
              },
              title: Text('Open Source Development'),
            ),
          ],
        ),
      ),
    );
  }
}
