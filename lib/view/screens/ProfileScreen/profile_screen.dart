import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
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
              color: CustomColor.primaryColor,
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
                                          CustomLogo.logo,
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
                                  fontFamily: CustomFont.poppins,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '@${userDataController.user!.username}',
                              style: TextStyle(
                                  fontFamily: CustomFont.poppins,
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300),
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
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: CustomFont.poppins,
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
                                        CustomIcon.doubleCheckIcon,
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
                                  color:
                                      CustomColor.primaryColor.withOpacity(0.8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Use only the needed space
                                    children: <Widget>[
                                      Image.asset(
                                        CustomIcon.sendMessageIcon,
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
                                      CustomIcon.moreIcon,
                                      height: 15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(
                              color: Colors.grey,
                              thickness: 0.2,
                              height: 40,
                            ), // First Divider
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly, // To space out the rows evenly
                              children: <Widget>[
                                // Each Column below represents one of the three rows you described
                                InkWell(
                                  onTap: () {
                                    userDataController
                                        .changePofileViewingOption(0);
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Image.asset(CustomIcon.photosIcon,
                                              height: 23),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Photos',
                                            style: TextStyle(
                                                fontFamily: CustomFont.poppins,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: userDataController
                                                .profilePostViewingOptions ==
                                            0,
                                        child: Container(
                                            height: 2.5,
                                            width: displayWidth(context) * 0.25,
                                            color: CustomColor.primaryColor
                                                .withOpacity(0.7)),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    userDataController
                                        .changePofileViewingOption(1);
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Image.asset(CustomIcon.videoIcon,
                                              height: 23),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Videos",
                                            style: TextStyle(
                                                fontFamily: CustomFont.poppins,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: userDataController
                                                .profilePostViewingOptions ==
                                            1,
                                        child: InkWell(
                                          onTap: () {
                                            userDataController
                                                .changePofileViewingOption(1);
                                          },
                                          child: Container(
                                              height: 2.5,
                                              width:
                                                  displayWidth(context) * 0.25,
                                              color: CustomColor.primaryColor
                                                  .withOpacity(0.7)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    userDataController
                                        .changePofileViewingOption(2);
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Image.asset(CustomIcon.savedIcon,
                                              height: 23),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Saved',
                                            style: TextStyle(
                                                fontFamily: CustomFont.poppins,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: userDataController
                                                .profilePostViewingOptions ==
                                            2,
                                        child: InkWell(
                                          onTap: () {
                                            userDataController
                                                .changePofileViewingOption(2);
                                          },
                                          child: Container(
                                              height: 2.5,
                                              width:
                                                  displayWidth(context) * 0.25,
                                              color: CustomColor.primaryColor
                                                  .withOpacity(0.7)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 0.2,
                              height: 30,
                            ), // Second Divider
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
