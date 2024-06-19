import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/routing.dart';
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
          List<Post> posts =
              userDataController.selfPosts[POST_TYPE.TEXT]!.toList();
          if (posts.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Text(
                    "You have not posted any blogs yet",
                    style:
                        TextStyle(fontFamily: CustomFont.poppins, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    CustomIcon.emptyIcon,
                    height: displayHeight(context) * 0.15,
                  )
                ],
              ),
            );
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
          List<Post> posts =
              userDataController.selfPosts[POST_TYPE.IMAGE]!.toList();
          if (posts.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Text(
                    "You have not posted any images yet",
                    style:
                        TextStyle(fontFamily: CustomFont.poppins, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    CustomIcon.emptyIcon,
                    height: displayHeight(context) * 0.15,
                  )
                ],
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemCount: posts.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.postDetailScreen, arguments: {
                      'post': posts[index],
                      'poster': userDataController.user!
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      fadeInCurve: Curves.easeInBack,
                      imageUrl: posts[index].postList.first.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }
        case 2:
          return const SizedBox();

        case 3:
          if (userDataController.user!.savedPosts == null ||
              userDataController.user!.savedPosts!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Text(
                    "You have not saved any posts yet",
                    style:
                        TextStyle(fontFamily: CustomFont.poppins, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    CustomIcon.emptyIcon,
                    height: displayHeight(context) * 0.15,
                  )
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userDataController.user!.savedPosts!.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder<Post>(
                  future: PostData.getPost(
                      userDataController.user!.savedPosts![index]),
                  builder:
                      (BuildContext context, AsyncSnapshot<Post> postSnap) {
                    if (postSnap.connectionState == ConnectionState.done &&
                        postSnap.hasData) {
                      return FutureBuilder<User>(
                        future: UserData.getUser(userID: postSnap.data!.userId),
                        builder: (BuildContext context,
                            AsyncSnapshot<User> posterSnap) {
                          if (posterSnap.connectionState ==
                                  ConnectionState.done &&
                              posterSnap.hasData) {
                            return FeedBox(
                                post: postSnap.data!, poster: posterSnap.data!);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
            );
          }
        default:
          return const SizedBox();
      }
    }
  }
}
