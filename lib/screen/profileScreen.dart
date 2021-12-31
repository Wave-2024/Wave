import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';

class profiletScreen extends StatefulWidget {
  @override
  State<profiletScreen> createState() => _profiletScreenState();
}

class _profiletScreenState extends State<profiletScreen> {
  bool viewPosts = true;
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: displayHeight(context) * 0.29,
                width: displayWidth(context),
                //color: Colors.pink,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      child: Image.asset(
                        'images/cover.jpg',
                        height: displayHeight(context) * 0.2,
                        width: displayWidth(context),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: displayWidth(context),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.white],
                              stops: [0, .7])),
                    ),
                    Positioned(
                        top: displayHeight(context) * 0.16,
                        child: Container(
                          height: displayHeight(context) * 0.1,
                          width: displayWidth(context) * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                color: Colors.orangeAccent, width: 2.3),
                          ),
                        )),
                    Positioned(
                        top: displayHeight(context) * 0.1655,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'images/male.jpg',
                            height: displayHeight(context) * 0.0905,
                            width: displayWidth(context) * 0.175,
                          ),
                        )),
                    Positioned(
                        top: displayHeight(context) * 0.02,
                        child: Text(
                          'Subhojeet Sahoo',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.05,
                              letterSpacing: 0.8),
                        )),
                    Positioned(
                        right: displayWidth(context) * 0.02,
                        top: displayHeight(context) * 0.005,
                        child: IconButton(
                          iconSize: displayWidth(context) * 0.08,
                          icon: const Icon(Icons.settings),
                          onPressed: () {},
                          color: Colors.white70,
                        )),
                  ],
                ),
              ),
              Text(
                "@alpha17-2",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: displayWidth(context) * 0.045,
                    fontWeight: FontWeight.bold),
              ),
              const Opacity(
                opacity: 0.0,
                child: Divider(
                  height: 2,
                ),
              ),
              Container(
                height: displayHeight(context) * 0.1,
                width: displayWidth(context),
                //color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '500',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.04),
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: displayWidth(context) * 0.036),
                        )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '258',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.04),
                        ),
                        Text(
                          'Followings',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: displayWidth(context) * 0.036),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '18',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.04),
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: displayWidth(context) * 0.036),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              const Opacity(
                opacity: 0.0,
                child: Divider(
                  height: 2,
                ),
              ),
              Container(
                height: displayHeight(context) * 0.08,
                width: displayWidth(context) * 0.62,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if(!viewPosts){
                              viewPosts=!viewPosts;
                            }
                          });
                        },
                        child: (viewPosts)
                            ? Card(
                          elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 45.0,right: 45,top: 8,bottom: 8),
                                    child: Text(
                                      'Posts',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: displayWidth(context) * 0.042,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            : Text('Posts',style: TextStyle(
                            color: Colors.black87,
                            fontSize: displayWidth(context) * 0.042,
                            fontWeight: FontWeight.bold),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if(viewPosts){
                              viewPosts=!viewPosts;
                            }
                          });
                        },
                        child: (!viewPosts)
                            ? Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 45.0,right: 45,top: 8,bottom: 8),
                              child: Text(
                                'Saved',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: displayWidth(context) * 0.042,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                            : Text('Saved',style: TextStyle(
                            color: Colors.black87,
                            fontSize: displayWidth(context) * 0.042,
                            fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
