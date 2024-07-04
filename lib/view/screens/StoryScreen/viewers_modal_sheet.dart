import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/view/reusable_components/user_container.dart';

class ViewersModalSheet extends StatelessWidget {
  List<dynamic> viewers;
  ViewersModalSheet({super.key, required this.viewers});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: Get.height * 0.7, minHeight: Get.height * 0.5),
      child: ListView.builder(
        itemCount: viewers.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<User>(
            future: UserData.getUser(userID: viewers[index]),
            builder: (BuildContext context, AsyncSnapshot<User> userSnap) {
              if (userSnap.connectionState == ConnectionState.done) {
                return UserContainerTile(user: userSnap.data!);
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
