import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/constants.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';

class ProfileScreen extends StatelessWidget {
  bool? other;

  ProfileScreen({super.key, this.other});

  Future<void> _handleRefresh(BuildContext context) async {
    // Assume setUser is asynchronous and fetches data
    await Provider.of<UserDataController>(context, listen: false)
        .setUser(userID: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display my profile if other param is null
      body: other == null
          ? RefreshIndicator(
              color: primaryColor,
              onRefresh: () => _handleRefresh(context),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Consumer<UserDataController>(
                  builder: (context, userDataController, child) {
                    if (userDataController.user == null) {
                      userDataController.setUser(
                          userID: FirebaseAuth.instance.currentUser!.uid);
                    }
                    switch (userDataController.userState) {
                      case USER.ABSENT:
                      case USER.LOADING:
                        // Using a SizedBox to ensure the scrollview has enough content to be scrollable
                        return SizedBox(
                          height: displayHeight(context),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
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
                                  (userDataController
                                          .user!.coverPicture.isNotEmpty)
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
                                            image: (userDataController.user!
                                                            .displayPicture !=
                                                        null &&
                                                    userDataController
                                                        .user!
                                                        .displayPicture!
                                                        .isNotEmpty)
                                                ? CachedNetworkImageProvider(
                                                    userDataController
                                                        .user!.displayPicture!,
                                                    scale: 1,
                                                  )
                                                : const AssetImage(
                                                        "assets/logo/logo.png")
                                                    as ImageProvider,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              userDataController.user!.name,
                              style: TextStyle(
                                  fontFamily: poppins,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                // color: Colors.red.shade100,
                                child: Text(
                                  userDataController.user!.bio ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: poppins,
                                      color: const Color(0xfbA9A9A9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  height: displayHeight(context) * 0.05,
                                  onPressed: () {
                                    printInfo(info: "tapped to follow");
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color: Colors.blue), // Border color
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Use only the needed space
                                    children: <Widget>[
                                      Image.asset(
                                        doubleCheckIcon,
                                        height: 20,
                                      ), // Icon with color
                                      const SizedBox(
                                          width:
                                              8), // Space between icon and text
                                      const Text('Following',
                                          style: TextStyle(
                                              color: Colors
                                                  .blue)), // Text with color
                                    ],
                                  ),
                                ),
                                MaterialButton(
                                  height: displayHeight(context) * 0.05,
                                  onPressed: () {
                                    printInfo(info: "tapped to follow");
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // Border color
                                  ),
                                  color: primaryColor.withOpacity(0.8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Use only the needed space
                                    children: <Widget>[
                                      Image.asset(
                                        sendMessageIcon,
                                        height: 20,
                                        color: Colors.white,
                                      ), // Icon with color
                                      const SizedBox(
                                          width:
                                              8), // Space between icon and text
                                      const Text('Message',
                                          style: TextStyle(
                                              color: Colors
                                                  .white)), // Text with color
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.1,
                                  child: MaterialButton(
                                    onPressed: () {},
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 0.3,
                                          color: Colors.black), // Bo
                                      borderRadius: BorderRadius.circular(10.0),
                                      // Border color
                                    ),
                                    child: Image.asset(
                                      moreIcon,
                                      height: 15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                    }
                  },
                ),
              ),
            )
          : const Scaffold(),
    );
  }
}
