import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'other_profile.dart';
import 'self_profile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  String? otherUserId = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.primaryBackGround,
        // Display my profile if other param is null
        body: otherUserId == null
            ? SelfProfile()
            : OtherProfile(
                otherUserId: otherUserId!,
              ));
  }
}
