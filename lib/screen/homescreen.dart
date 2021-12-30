import 'package:flutter/material.dart';
class homescreen extends StatelessWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold( body : Container(
        child: Center(child: Text('Hello User'),),
      ),
    );
  }
}
