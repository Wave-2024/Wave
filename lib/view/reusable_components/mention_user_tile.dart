import 'package:flutter/material.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';

class MentionUserTile extends StatelessWidget {
  User user;
  bool isMentioned;
  final VoidCallback onPressed;
  MentionUserTile(
      {super.key,
      required this.user,
      required this.isMentioned,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onPressed();
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            user.name,
            style:
                TextStyle(fontFamily: CustomFont.poppins, letterSpacing: 0.1),
          ),
          SizedBox(
            width: 2,
          ),
          Visibility(
              visible: user.verified,
              child: Image.asset(
                CustomIcon.verifiedIcon,
                height: 15,
              ))
        ],
      ),
      trailing: Visibility(
          visible: isMentioned,
          child: Image.asset(
            CustomIcon.doubleCheckIcon,
            height: 20,
          )),
    );
  }
}
