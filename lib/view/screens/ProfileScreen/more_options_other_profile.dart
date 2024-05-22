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
          leading: Icon(Icons.report),
          title: Text('Report',
              style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () async {
            // report functionalities
          },
        ),
        ListTile( 
          leading: Icon(Icons.block_flipped),
          title: Text('Block',
            style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
            onTap: () async {
              //block functionalities
            },      
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text('Share To', 
          style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () {
            //Share Profile Functionalities
          },
        ),
        ListTile(
          leading: Icon(Icons.link),
          title: Text('Website Url',
          style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () {
            //Website Url functionalities
          },
        ),
        ListTile(
          leading: Icon(Icons.cancel),
          title: Text('Cancel',
          style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () {
            //Cancel Functionalities
          },
        ),
      ],
    ));
  }
}
