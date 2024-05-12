import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/view/reusable_components/user_container.dart';

class ListUsers extends StatefulWidget {
  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List<dynamic> users = [];
  String title = "";

  @override
  void initState() {
    super.initState();
    users = Get.arguments[0];
    title = Get.arguments[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: CustomFont.poppins,
            fontSize: 16.5,
            letterSpacing: -0.1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: CustomColor.primaryBackGround,
      ),
      backgroundColor: CustomColor.primaryBackGround,
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<User>(
            future: UserData.getUser(userID: users[index].toString()),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<User> user) {
              if (user.connectionState == ConnectionState.done &&
                  user.hasData) {
                return UserContainerTile(user: user.data!);
              }
              return SizedBox();
            },
          );
        },
      ),
    );
  }
}
