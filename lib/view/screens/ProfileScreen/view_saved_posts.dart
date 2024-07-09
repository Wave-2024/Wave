import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/reusable_components/feedbox.dart';

class ViewSavedPosts extends StatelessWidget {
  ViewSavedPosts({super.key, required this.userDataController});
  UserDataController userDataController;

  @override
  Widget build(BuildContext context) {
    if (userDataController.fetch_saved_posts == FETCH_SAVED_POSTS.NOT_FETCHED) {
      userDataController.getSavedPosts();
    } else if (userDataController.fetch_saved_posts ==
        FETCH_SAVED_POSTS.FETCHING) {
      return const Center(child: CircularProgressIndicator());
    } else {
      switch (userDataController.savedPostOptions) {
        case 0:
          List<Post> posts =
              userDataController.savedPosts[POST_TYPE.TEXT]!.toList();
          if (posts.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Text(
                    "You have not saved any blogs yet",
                    style:
                        TextStyle(fontFamily: CustomFont.poppins, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    CustomIcon.emptyIcon,
                    height: Get.height * 0.15,
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
                return FutureBuilder<User>(
                  future: UserData.getUser(userID: posts[index].userId),
                  builder:
                      (BuildContext context, AsyncSnapshot<User> userSnap) {
                    if (userSnap.connectionState == ConnectionState.done &&
                        userSnap.hasData) {
                      return FeedBox(
                          post: posts[index], poster: userSnap.data!);
                    } else {
                      return SizedBox();
                    }
                  },
                );
              },
            );
          }

        case 1:
          List<Post> posts =
              userDataController.savedPosts[POST_TYPE.IMAGE]!.toList();
          if (posts.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Text(
                    "You have not saved any images yet",
                    style:
                        TextStyle(fontFamily: CustomFont.poppins, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    CustomIcon.emptyIcon,
                    height: Get.height * 0.15,
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
                  onTap: () async {
                    User poster =
                        await UserData.getUser(userID: posts[index].userId);
                    Get.toNamed(AppRoutes.postDetailScreen, arguments: {
                      'post': posts[index],
                      'poster': poster,
                      'mentionedUserId': posts[index].mentions.isNotEmpty
                          ? posts[index].mentions.first
                          : null
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

        default:
          return SizedBox();
      }
    }
    return SizedBox();
  }
}