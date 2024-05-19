import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/routing.dart';

class UserContainerTile extends StatelessWidget {
  User user;
  UserContainerTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(vertical: -0.5),
      onTap: () {
        Get.toNamed(AppRoutes.profileScreen, arguments: user.id);
      },
      subtitle: Text(
        user.username,
        style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 11),
      ),
      leading: CircleAvatar(
        backgroundImage:
            (user.displayPicture != null && user.displayPicture!.isNotEmpty)
                ? NetworkImage(user.displayPicture!)
                : null,
        radius: 20,
        child: user.displayPicture == null || user.displayPicture!.isEmpty
            ? const Icon(Icons.person)
            : null,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            user.name,
            style: TextStyle(
                fontFamily: CustomFont.poppins,
                fontSize: 12.5,
                letterSpacing: 0.1),
          ),
          const SizedBox(
            width: 2,
          ),
          Visibility(
              visible: user.verified,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Image.asset(
                  CustomIcon.verifiedIcon,
                  height: 12.2,
                ),
              ))
        ],
      ),
    );
  }
}
