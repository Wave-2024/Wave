import 'package:flutter/material.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';

class ViewPosts extends StatelessWidget {
  final int option;
  final UserDataController userDataController;
  const ViewPosts(
      {super.key, required this.option, required this.userDataController});

  @override
  Widget build(BuildContext context) {
    if (option == 0) {
      if (userDataController.blogPosts.isEmpty) {
        userDataController.getAllBlogPosts();
      }
      if (userDataController.fetchingPosts) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (userDataController.blogPosts.isNotEmpty) {
          return ListView.builder(
            itemCount: userDataController.blogPosts.length,
            itemBuilder: (BuildContext context, int index) {
              return const Text("");
            },
          );
        } else {
          return const SizedBox();
        }
      }
    } else if (option == 1) {
      return const SizedBox();
    } else if (option == 2) {
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }
}
