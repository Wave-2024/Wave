import 'package:flutter/material.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/screens/ProfileScreen/more_options_self.dart';
import 'package:wave/view/screens/ProfileScreen/view_posts.dart';

class SelfProfile extends StatelessWidget {
  SelfProfile({super.key});

  Future<void> _handleRefresh(BuildContext context) async {
    // Assume setUser is asynchronous and fetches data
    await Provider.of<UserDataController>(context, listen: false)
        .setUser(userID: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final widthOfRedBar = displayWidth(context) * 0.2;
    return RefreshIndicator(
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
                  child: const Center(child: CircularProgressIndicator()),
                );
              case USER.PRESENT:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: displayHeight(context) * 0.3,
                      width: double.infinity,
                      // color: Colors.red.shade100,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        fit: StackFit.loose,
                        children: [
                          (userDataController.user!.coverPicture.isNotEmpty)
                              ? InkWell(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.viewImageScreen,
                                        arguments: userDataController
                                            .user!.coverPicture);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        userDataController.user!.coverPicture,
                                    height: displayHeight(context) * 0.22,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  CustomLogo.logo,
                                  height: displayHeight(context) * 0.22,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                          Positioned(
                            bottom: 0,
                            child: InkWell(
                              onTap: () {
                                if (userDataController.user!.displayPicture !=
                                        null &&
                                    userDataController
                                        .user!.displayPicture!.isNotEmpty) {
                                  Get.toNamed(AppRoutes.viewImageScreen,
                                      arguments: userDataController
                                          .user!.displayPicture);
                                }
                              },
                              child: CircleAvatar(
                                radius: displayWidth(context) * 0.162,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: displayWidth(context) * 0.15,
                                  backgroundImage: (userDataController
                                                  .user!.displayPicture !=
                                              null &&
                                          userDataController
                                              .user!.displayPicture!.isNotEmpty)
                                      ? CachedNetworkImageProvider(
                                          userDataController
                                              .user!.displayPicture!)
                                      : const AssetImage("assets/logo/logo.png")
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userDataController.user!.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: CustomFont.poppins,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Visibility(
                            visible: userDataController.user!.verified,
                            child: Image.asset(
                              CustomIcon.verifiedIcon,
                              height: 18,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '@${userDataController.user!.username}',
                      style: TextStyle(
                          fontFamily: CustomFont.poppins,
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        // color: Colors.red.shade100,
                        child: Text(
                          userDataController.user!.bio ?? "",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: CustomFont.poppins,
                              color: Colors.black54,
                              fontSize: 13.6,
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
                          height: displayHeight(context) * 0.045,
                          onPressed: () {
                            Get.toNamed(AppRoutes.listUsersScreen, arguments: [
                              userDataController.user!.followers,
                              "Followers"
                            ]);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                                color: Colors.blue), // Border color
                          ),
                          child: Text(
                              '${userDataController.user!.followers.length}${(userDataController.user!.followers.length > 1) ? ' Followers' : ' Follower'}',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: CustomFont.poppins,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                        MaterialButton(
                          height: displayHeight(context) * 0.045,
                          onPressed: () {
                            Get.toNamed(AppRoutes.listUsersScreen, arguments: [
                              userDataController.user!.following,
                              "Following"
                            ]);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // Border color
                          ),
                          color: CustomColor.primaryColor.withOpacity(0.8),
                          child: Text(
                              '${userDataController.user!.following.length} Following',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: CustomFont.poppins,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                        SizedBox(
                          width: displayWidth(context) * 0.1,
                          child: MaterialButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return const MoreOptionsForSelfProfile();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 0.3, color: Colors.black), // Bo
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
                            userDataController.changePofileViewingOption(0);
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(CustomIcon.textPostIcon,
                                      height: 16),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Blogs',
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 11.5),
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
                                    width: widthOfRedBar,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            userDataController.changePofileViewingOption(1);
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(CustomIcon.photosIcon,
                                      height: 16),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Photos',
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 11.5),
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
                                child: Container(
                                    height: 2.5,
                                    width: widthOfRedBar,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            userDataController.changePofileViewingOption(2);
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(CustomIcon.videoIcon, height: 16),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Videos",
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 11.5),
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
                                child: Container(
                                    height: 2.5,
                                    width: widthOfRedBar,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            userDataController.changePofileViewingOption(3);
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(CustomIcon.savedIcon, height: 16),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Saved',
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 11.5),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: userDataController
                                        .profilePostViewingOptions ==
                                    3,
                                child: Container(
                                    height: 2.5,
                                    width: widthOfRedBar,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.7)),
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
                    ),
                    ViewPosts(
                      option: userDataController.profilePostViewingOptions,
                      userDataController: userDataController,
                    )
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
