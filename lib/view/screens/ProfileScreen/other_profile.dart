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
            User otherUser = otherUserSnapshot.data!;
            // TODO : @Shruti-1910 Implement the other profile UI
            return Center(child: Text(otherUser.name));
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
