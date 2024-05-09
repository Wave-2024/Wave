import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
import 'package:wave/utils/device_size.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Profile",
            style: TextStyle(
                fontSize: 16.5,
                letterSpacing: -0.1,
                fontFamily: CustomFont.poppins,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          iconTheme: IconThemeData(color: Colors.black54),
        ),
        body: Consumer<UserDataController>(
          builder: (context, userDataController, child) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: displayHeight(context) * 0.32,
                    width: double.infinity,
                    // color: Colors.red.shade100,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      fit: StackFit.loose,
                      children: [
                        (userDataController.user!.coverPicture.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: userDataController.user!.coverPicture,
                                height: displayHeight(context) * 0.25,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                CustomLogo.logo,
                                height: displayHeight(context) * 0.25,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                        Positioned(
                          bottom: 0,
                          child: CircleAvatar(
                            // Bigger radius avatar
                            radius: displayWidth(context) * 0.162,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              // Image avatar
                              radius: displayWidth(context) * 0.15,
                              backgroundImage: (userDataController
                                              .user!.displayPicture !=
                                          null &&
                                      userDataController
                                          .user!.displayPicture!.isNotEmpty)
                                  ? CachedNetworkImageProvider(
                                      userDataController.user!.displayPicture!)
                                  : const AssetImage("assets/logo/logo.png")
                                      as ImageProvider,
                            ),
                          ),
                        ),
                        Positioned(
                            right: 10,
                            bottom: displayHeight(context) * 0.05,
                            child: InkWell(
                              onTap: () {
                                "Changing Cover Picture".printInfo();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Image.asset(
                                  CustomIcon.changeImageIcon,
                                  color: CustomColor.primaryColor,
                                  height: 22,
                                ),
                              ),
                            )),
                        Positioned(
                            right: displayWidth(context) * 0.29,
                            bottom: displayHeight(context) * 0.02,
                            child: InkWell(
                              onTap: () {
                                "Changing Display Picture".printInfo();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Image.asset(
                                  CustomIcon.changeImageIcon,
                                  color: CustomColor.primaryColor,
                                  height: 22,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
