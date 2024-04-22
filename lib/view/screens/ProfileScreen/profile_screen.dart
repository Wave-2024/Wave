import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/constants.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';

class ProfileScreen extends StatelessWidget {
  bool? self;
  ProfileScreen({super.key, this.self});

  @override
  Widget build(BuildContext context) {
    if (self == null) {
      return Scaffold(body: Consumer<UserDataController>(
        builder: (context, userDataController, child) {
          if (userDataController.user == null) {
            userDataController.setUser(
                userID: FirebaseAuth.instance.currentUser!.uid);
          }
          switch (userDataController.userState) {
            case USER.ABSENT:
              return Center(child: CircularProgressIndicator());
            case USER.LOADING:
              return Center(child: CircularProgressIndicator());
            case USER.PRESENT:
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: displayHeight(context) * 0.45,
                    width: double.infinity,
                    // color: Colors.red.shade100,
                    child: Stack(
                      children: [
                        (userDataController.user!.coverPicture.isNotEmpty)
                            ? Image.network(
                                userDataController.user!.coverPicture,
                                height: displayHeight(context) * 0.35,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                logo,
                                height: displayHeight(context) * 0.35,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: displayHeight(context) * 0.23,
                            width: displayWidth(context) * 0.2,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: (userDataController
                                                  .user!.displayPicture !=
                                              null &&
                                          userDataController
                                              .user!.displayPicture!.isNotEmpty)
                                      ? CachedNetworkImageProvider(
                                          userDataController
                                              .user!.displayPicture!,
                                          scale: 1,
                                        )
                                      : AssetImage("assets/logo/logo.png")
                                          as ImageProvider,
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
          }
        },
      ));
    } else {
      return Scaffold();
    }
  }
}
