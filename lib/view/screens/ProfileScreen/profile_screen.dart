import 'package:flutter/material.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'self_profile.dart';

class ProfileScreen extends StatelessWidget {
  bool? other;

  ProfileScreen({super.key, this.other});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      // Display my profile if other param is null
      body: other == null ? SelfProfile() : const Scaffold(),
    );
  }
}
