import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/services/AuthService.dart';
import 'package:nexus/utils/devicesize.dart';

class feedScreen extends StatelessWidget {
  final authservice _auth = authservice(FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: displayHeight(context) * 0.06,
                width: displayWidth(context),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 20, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.50),
                        child: Text(
                          "Nexus",
                          style: TextStyle(
                              color: Colors.orange[600],
                              fontSize: displayWidth(context) * 0.06,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.notification_add_outlined)),
                          IconButton(
                              onPressed: () {
                                _auth.signOut();
                              },
                              icon: const Icon(Icons.settings))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const Opacity(opacity: 0.0, child: Divider()),
              Padding(
                padding: const EdgeInsets.all(21.0),
                child: Container(
                  height: displayHeight(context) * 0.7,
                  width: displayWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      height: displayHeight(context) * 0.65,
                      width: displayWidth(context) * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        'images/male.jpg',
                                        height: displayHeight(context) * 0.075,
                                        width: displayWidth(context) * 0.175,
                                      ),
                                    ),
                                    const VerticalDivider(),
                                    Text(
                                      'alpha17-2',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              displayWidth(context) * 0.042,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.chat))
                              ],
                            ),
                            Opacity(
                              opacity: 0.0,
                              child: Divider(
                                height: displayHeight(context) * 0.022,
                              ),
                            ),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  'images/radhe.jpg',
                                  height: displayHeight(context) * 0.42,
                                  width: displayWidth(context) * 0.68,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            //Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Container(
                                height: displayHeight(context) * 0.075,
                                width: displayWidth(context) * 0.8,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: displayWidth(context) * 0.04,
                                          child: Center(
                                            child: Image.asset(
                                              'images/like.png',
                                              height: displayHeight(context) *
                                                  0.035,
                                            ),
                                          ),
                                        ),
                                        const Opacity(
                                            opacity: 0.0,
                                            child: VerticalDivider()),
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: displayWidth(context) * 0.04,
                                          child: Center(
                                            child: Image.asset(
                                              'images/comment.png',
                                              height: displayHeight(context) *
                                                  0.035,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: displayWidth(context) * 0.04,
                                      child: Center(
                                        child: Image.asset(
                                          'images/bookmark.png',
                                          height:
                                              displayHeight(context) * 0.035,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                '5012 likes',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: displayWidth(context) * 0.035,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
