import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/view/reusable_components/feedbox.dart';

class ViewPosts extends StatelessWidget {
  final int option;
  final UserDataController userDataController;
  const ViewPosts(
      {super.key, required this.option, required this.userDataController});

  @override
  Widget build(BuildContext context) {
    if (userDataController.fetch_self_post == FETCH_SELF_POST.FETCHING) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (userDataController.fetch_self_post == FETCH_SELF_POST.NOT_FETCHED) {
        userDataController.getAllPosts();
      }
      switch (option) {
        case 0:
          List<Post> posts = userDataController.selfPosts[POST_TYPE.TEXT]!.toList();
          if (posts.isEmpty) {
            return SizedBox();
          } else {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return FeedBox(
                    post: posts[index], poster: userDataController.user!);
              },
            );
          }

        case 1:
          List<Post> posts = userDataController.selfPosts[POST_TYPE.IMAGE]!.toList();
          if (posts.isEmpty) {
            return SizedBox();
          } else {
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemCount: posts.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.easeInBack,
                    imageUrl: posts[index].postList.first.url,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }
        case 2:
          return SizedBox();

        case 3:
          return SizedBox();

        default:
          return SizedBox();
      }
    }
  }
}
