import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/notification_data.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/services/notification_service.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
import 'package:wave/utils/device_size.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/models/notification_model.dart' as not;
import 'package:wave/view/screens/ProfileScreen/more_options_other_profile.dart';

class OtherProfile extends StatefulWidget {
  final String otherUserId;
  const OtherProfile({super.key, required this.otherUserId});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  Future<void> _handleRefresh(BuildContext context) async {
    await Provider.of<UserDataController>(context, listen: false)
        .updateOtherUserData(widget.otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: CustomColor.primaryColor,
      onRefresh: () => _handleRefresh(context),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Consumer<UserDataController>(
          builder: (context, userDataController, child) {
            if (!userDataController.otherUserDataPresent(widget.otherUserId)) {
              userDataController.updateOtherUserData(widget.otherUserId);
              return const Center(child: CircularProgressIndicator());
            } else {
              User otherUser =
                  userDataController.otherUsers[widget.otherUserId]!;
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
                        // Cover photo
                        (otherUser.coverPicture.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: otherUser.coverPicture,
                                height: displayHeight(context) * 0.22,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                CustomLogo.logo,
                                height: displayHeight(context) * 0.22,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                        Positioned(
                            top: displayHeight(context) * 0.05,
                            left: 0,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.white,
                            )),
                        Positioned(
                          bottom: 0,
                          child: CircleAvatar(
                            radius: displayWidth(context) * 0.162,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: displayWidth(context) * 0.15,
                              backgroundImage:
                                  (otherUser.displayPicture != null &&
                                          otherUser.displayPicture!.isNotEmpty)
                                      ? CachedNetworkImageProvider(
                                          otherUser.displayPicture!)
                                      : const AssetImage("assets/logo/logo.png")
                                          as ImageProvider,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: MaterialButton(
                            padding: const EdgeInsets.all(8),
                            height: displayHeight(context) * 0.05,
                            onPressed: () async {
                              if (userDataController
                                  .followingUser(otherUser.id)) {
                                // Current user is following the other user
                                // Try to unfollow
                                CustomResponse? customResponse =
                                    await userDataController
                                        .unFollowUser(widget.otherUserId);
                              } else {
                                // Current user is not following the other user
                                // Try to follow
                                CustomResponse? customResponse =
                                    await userDataController
                                        .followUser(widget.otherUserId);
                                not.Notification notification =
                                    not.Notification(
                                  createdAt: DateTime.now(),
                                  userWhoFollowed: userDataController.user!.id,
                                  forUser: widget.otherUserId,
                                  id: "",
                                  seen: false,
                                  type: 'follow',
                                );

                                NotificationData.createNotification(
                                    notification: notification);

                                // TODO : Send push notification
                                // NotificationService.sendPushNotification(fcmToken: fcmToken, title: title, message: message)
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: Colors.blue), // Border color
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min, // Use only the needed space
                              children: <Widget>[
                                Image.asset(
                                  (userDataController
                                          .followingUser(otherUser.id))
                                      ? CustomIcon.doubleCheckIcon
                                      : CustomIcon.followIcon,
                                  height: (userDataController
                                          .followingUser(otherUser.id))
                                      ? 18
                                      : 16,
                                ), // Icon with color
                                const SizedBox(
                                    width: 5), // Space between icon and text
                                Text(
                                    (userDataController
                                            .followingUser(otherUser.id))
                                        ? 'Following'
                                        : 'Follow',
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 12,
                                        color: Colors.blue)), // Text with color
                              ],
                            ),
                          ),
                        ),
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
                        otherUser.name,
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
                          visible: otherUser.verified,
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
                    '@${otherUser.username}',
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
                        otherUser.bio ?? "",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: CustomFont.poppins,
                            color: const Color(0xfbA9A9A9),
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
                          Get.toNamed(AppRoutes.listUsersScreen,
                              arguments: [otherUser.followers, "Followers"]);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.blue), // Border color
                        ),
                        child: Text(
                            '${otherUser.followers.length}${(otherUser.followers.length > 1) ? ' Followers' : ' Follower'}',
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: CustomFont.poppins,
                                fontSize: 13)),
                      ),
                      MaterialButton(
                        height: displayHeight(context) * 0.045,
                        onPressed: () {
                          Get.toNamed(AppRoutes.listUsersScreen,
                              arguments: [otherUser.following, "Following"]);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // Border color
                        ),
                        color: CustomColor.primaryColor.withOpacity(0.8),
                        child: Text('${otherUser.following.length} Following',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: CustomFont.poppins,
                                fontSize: 13)),
                      ),
                      SizedBox(
                        width: displayWidth(context) * 0.1,
                        child: MaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return const MoreOptionForOtherProfile();
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
                  ),

                  // First Divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // To space out the rows evenly
                    children: <Widget>[
                      // Each Column below represents one of the three rows you described
                      InkWell(
                        onTap: () {
                          userDataController.changeOtherProfileViewOptions(0);
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(CustomIcon.savedIcon, height: 18),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'All',
                                  style: TextStyle(
                                      fontFamily: CustomFont.poppins,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible:
                                  userDataController.otherProfileViewOptions ==
                                      0,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                    height: 2.5,
                                    width: displayWidth(context) * 0.25,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.7)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          userDataController.changeOtherProfileViewOptions(1);
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(CustomIcon.photosIcon, height: 18),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Photos',
                                  style: TextStyle(
                                      fontFamily: CustomFont.poppins,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible:
                                  userDataController.otherProfileViewOptions ==
                                      1,
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
                          userDataController.changeOtherProfileViewOptions(2);
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(CustomIcon.videoIcon, height: 18),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Videos",
                                  style: TextStyle(
                                      fontFamily: CustomFont.poppins,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible:
                                  userDataController.otherProfileViewOptions ==
                                      2,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                    height: 2.5,
                                    width: displayWidth(context) * 0.25,
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
    );
  }
}

/*

*/