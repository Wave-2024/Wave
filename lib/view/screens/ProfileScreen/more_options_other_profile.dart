import 'package:flutter/material.dart';
import 'package:wave/utils/constants/custom_fonts.dart';

class MoreOptionForOtherProfile extends StatelessWidget {
  const MoreOptionForOtherProfile({super.key});

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
          },
        ),
      ],
    ));
  }
}
