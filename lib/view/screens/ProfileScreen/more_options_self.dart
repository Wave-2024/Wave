import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/auth_screen_controller.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/routing.dart';

class MoreOptionsForSelfProfile extends StatelessWidget {
  const MoreOptionsForSelfProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Wrap(
      children: [
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout',
              style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () async {
            // Close the bottom sheet
            await Provider.of<AuthScreenController>(context, listen: false)
                .signOut(firebaseAuth: FirebaseAuth.instance);
            Get.offAllNamed(AppRoutes.loginScreen);
          },
        ),
        Consumer<UserDataController>(
          builder: (context, userDataController, child) {
            return ListTile(
              leading: CircleAvatar(
                radius: 14,
                backgroundImage: userDataController.user!.displayPicture !=
                            null &&
                        userDataController.user!.displayPicture!.isNotEmpty
                    ? CachedNetworkImageProvider(
                        userDataController.user!.displayPicture!)
                    : AssetImage(CustomIcon.profileFullIcon) as ImageProvider,
              ),
              title: Text(
                'Edit Profile',
                style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14),
              ),
              onTap: () async {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.editProfileScreen,
                    arguments: userDataController.user!);
              },
            );
          },
        ),
      ],
    ));
  }
}
