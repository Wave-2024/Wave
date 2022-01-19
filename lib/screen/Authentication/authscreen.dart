import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus/screen/Authentication/loginscreen.dart';
import 'package:nexus/screen/Authentication/registerScreen.dart';
import 'package:nexus/utils/devicesize.dart';

class authScreen extends StatelessWidget {
  const authScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white,
                  Colors.pink[100]!.withOpacity(0.01),
                  Colors.pink[100]!.withOpacity(0.01),
                ]),
          ),
          height: displayHeight(context),
          width: displayWidth(context),
          //color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nexus",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.12,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          Text(
                            'Find people with the same \ninterests as you',
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black54,
                                fontSize: displayWidth(context) * 0.045),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'images/nexux.png',
                  height: displayHeight(context) * 0.45,
                  width: displayWidth(context) * 0.9,
                  fit: BoxFit.contain,
                ),
                Opacity(
                  opacity: 0.0,
                  child: Divider(
                    height: displayHeight(context) * 0.03,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => loginScreen(),
                        ));
                  },
                  child: Container(
                    height: displayHeight(context) * 0.07,
                    width: displayWidth(context) * 0.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'Log in',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: displayWidth(context) * 0.04),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Divider(
                    height: displayHeight(context) * 0.03,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => registerScreen(),
                        ));
                  },
                  child: Container(
                    height: displayHeight(context) * 0.07,
                    width: displayWidth(context) * 0.8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.deepOrange,
                            Colors.deepOrangeAccent,
                            Colors.orange[600]!,
                          ]),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: displayWidth(context) * 0.04),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
