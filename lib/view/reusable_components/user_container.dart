import 'package:flutter/material.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';

class UserContainerTile extends StatelessWidget {
  User user;
  UserContainerTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // TODO : Navigate to the profile screen
        // Get.toNamed()
      },
      subtitle: Text(
        user.username,
        style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 13),
      ),
      leading: CircleAvatar(
        backgroundImage:
            (user.displayPicture != null && user.displayPicture!.isNotEmpty)
                ? NetworkImage(user.displayPicture!)
                : null,
        radius: 25,
        child: user.displayPicture == null || user.displayPicture!.isEmpty
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(
        user.name,
        style: TextStyle(fontFamily: CustomFont.poppins, letterSpacing: 0.1),
      ),
    );
  }
}
