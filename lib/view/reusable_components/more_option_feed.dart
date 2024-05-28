import 'package:flutter/material.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';


class MoreOptionsForFeedPost extends StatelessWidget {
  final Post post;
  const MoreOptionsForFeedPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Wrap(
      children: [
        ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text('Settings',
              style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () {
            //Settings
          },
        ),
        ListTile(
          leading: Icon(Icons.block_outlined),
          title: Text('Blocked Contacts',
              style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () {
            //Help
          },
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('About',
              style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () {
            //About
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline_outlined),
          title: Text('Help',
              style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () {
            //Help
          },
        ),
      ],
    ));
  }
}
