import 'package:flutter/material.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/view/screens/ProfileScreen/more_options.dart';

class OtherProfile extends StatefulWidget {
  final String otherUserId;
  const OtherProfile({super.key, required this.otherUserId});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  Future<void> _handleRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: FutureBuilder<User>(
        future: UserData.getUser(userID: widget.otherUserId),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<User> otherUserSnapshot) {
          if (otherUserSnapshot.connectionState == ConnectionState.done &&
              otherUserSnapshot.data != null) {
            User? otherUser = otherUserSnapshot.data!;
            // TODO : @Shruti-1910 Implement the other profile UI
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
                        bottom: 0,
                        child: CircleAvatar(
                          radius: displayWidth(context) * 0.162,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: displayWidth(context) * 0.15,
                            backgroundImage: (otherUser.displayPicture !=
                                        null &&
                                    otherUser.displayPicture!.isNotEmpty)
                                ? CachedNetworkImageProvider(
                                    otherUser.displayPicture!)
                                : const AssetImage("assets/logo/logo.png")
                                    as ImageProvider,
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
                        printInfo(info: "tapped to follow");
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Colors.blue), // Border color
                      ),
                      child: Text('10C Followers',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: CustomFont.poppins,
                              fontSize: 13)),
                    ),
                    MaterialButton(
                      height: displayHeight(context) * 0.045,
                      onPressed: () {
                        printInfo(info: "tapped to follow");
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // Border color
                      ),
                      color: CustomColor.primaryColor.withOpacity(0.8),
                      child: Text('170 Following',
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
                              return const MoreOptionsModalSheet();
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
                            visible: false,
                            child: Container(
                                height: 2.5,
                                width: displayWidth(context) * 0.25,
                                color:
                                    CustomColor.primaryColor.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        
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
                            visible: false,
                            child: InkWell(
                              onTap: () {
                                
                              },
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
                                'Saved',
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
                            visible: false,
                            child: InkWell(
                              onTap: () {
                              },
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}