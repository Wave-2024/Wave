import 'package:flutter/material.dart';
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
    );
  }
}
