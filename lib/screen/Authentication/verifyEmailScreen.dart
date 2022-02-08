import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/AuthService.dart';
import '../../utils/devicesize.dart';

class verifyEmailScreen extends StatelessWidget {
  final authservice _auth = authservice(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/wave.jpg',
                height: displayHeight(context) * 0.3,
                width: displayWidth(context),
                fit: BoxFit.cover,
              ),
              const Opacity(opacity: 0.0, child: Divider()),
              Text(
                'Welcome to Wave',
                style: TextStyle(
                    color: Colors.orange,
                    fontFamily: "Pacifico",
                    fontSize: displayWidth(context) * 0.075,
                    fontWeight: FontWeight.w300),
              ),
              const Opacity(opacity: 0.0, child: Divider()),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text(
                  'We are elated to have you with us. To make the most out of the benefits of the app, kindly follow the simple steps in their respective order.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: displayWidth(context) * 0.045,
                  ),
                ),
              ),
              const Opacity(opacity: 0.0, child: Divider()),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: displayWidth(context) * 0.04,
                      backgroundColor: Colors.indigo,
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: displayWidth(context) * 0.04,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verify email',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: displayWidth(context) * 0.04,
                            ),
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.005,
                          ),
                          Text(
                            'Verify your email address using the link we sent.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: displayWidth(context) * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Opacity(opacity: 0.0, child: Divider()),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: displayWidth(context) * 0.04,
                      backgroundColor: Colors.indigo,
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: displayWidth(context) * 0.04,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: displayWidth(context) * 0.04,
                            ),
                          ),
                          SizedBox(
                            height: displayHeight(context) * 0.005,
                          ),
                          Text(
                            'Logout and login after following the first step.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: displayWidth(context) * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Opacity(opacity: 0.0, child: Divider()),
              GestureDetector(
                onTap: () => _auth.signOut(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(15)),
                      color: Colors.orange[300]),
                  height: displayHeight(context) * 0.065,
                  width: displayWidth(context) * 0.4,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LOGOUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: displayWidth(context) * 0.045,
                          ),
                        ),
                        SizedBox(
                          width: displayWidth(context) * 0.02,
                        ),
                        Icon(
                          Icons.logout,
                          size: displayWidth(context) * 0.055,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
