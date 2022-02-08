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
                            "Wave",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.12,
                              fontWeight: FontWeight.w400,
                              color: Colors.indigo,
                              fontFamily: 'Pacifico'
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
                TextButton(
                  style: ButtonStyle(
                      splashFactory: InkSplash.splashFactory,
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black45),
                          borderRadius: BorderRadius.circular(18))),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 6, bottom: 6),
                    child: Text('Log In',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: displayWidth(context) * 0.04)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const loginScreen(),
                        ));
                  },
                ),

                Opacity(
                  opacity: 0.0,
                  child: Divider(
                    height: displayHeight(context) * 0.03,
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      splashFactory: InkSplash.splashFactory,
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18))),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orangeAccent)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 6, bottom: 6),
                    child: Text('Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: displayWidth(context) * 0.04)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const registerScreen(),
                        ));
                  },
                  ),

              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
