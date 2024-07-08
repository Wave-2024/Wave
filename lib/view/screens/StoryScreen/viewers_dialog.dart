import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/view/reusable_components/user_container.dart';

class ViewersDialog extends StatelessWidget {
  List<dynamic> viewers;
  ViewersDialog({super.key, required this.viewers});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      width: Get.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Icon(
            Icons.remove,
            color: Colors.grey[600],
          ),
          Expanded(
              child: ListView.builder(
            itemCount: viewers.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<User>(
                future: UserData.getUser(userID: viewers[index]),
                builder: (BuildContext context, AsyncSnapshot<User> userSnap) {
                  if (userSnap.connectionState == ConnectionState.done) {
                    return UserContainerTile(user: userSnap.data!);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            },
          ))
        ],
      ),
    );

    
  }
}
