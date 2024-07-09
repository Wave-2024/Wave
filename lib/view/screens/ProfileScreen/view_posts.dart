import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/reusable_components/feedbox.dart';
import 'package:wave/view/screens/ProfileScreen/view_saved_posts.dart';

class ViewPosts extends StatelessWidget {
  final widthOfRedBar = Get.width * 0.2;

  final int option;
  final UserDataController userDataController;
  ViewPosts(
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
                      'poster': userDataController.user!,
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
            return Column(
              children: [
                Container(
                  height: Get.height * 0.06,
                  width: Get.width,
                  // color: Colors.blue.shade100,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          userDataController.changeSavedPostOptions(0);
                        },
                        child: Container(
                          width: Get.width * 0.33,
                          // color: Colors.pink.shade100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(CustomIcon.textPostIcon,
                                      height: 16),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Blogs',
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 11.5),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible:
                                    userDataController.savedPostOptions == 0,
                                child: Container(
                                    height: 2.5,
                                    width: widthOfRedBar,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          userDataController.changeSavedPostOptions(1);
                        },
                        child: Container(
                          width: Get.width * 0.33,
                          // color: Colors.green.shade100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(CustomIcon.photosIcon,
                                      height: 16),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Photos',
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 11.5),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible:
                                    userDataController.savedPostOptions == 1,
                                child: Container(
                                    height: 2.5,
                                    width: widthOfRedBar,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          userDataController.changeSavedPostOptions(2);
                        },
                        child: Container(
                          width: Get.width * 0.33,
                          // color: Colors.yellow.shade100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(CustomIcon.videoIcon, height: 16),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Videos",
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 11.5),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible:
                                    userDataController.savedPostOptions == 2,
                                child: Container(
                                    height: 2.5,
                                    width: widthOfRedBar,
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ViewSavedPosts(
                  userDataController: userDataController,
                ),
              ],
            );
          }
        default:
          return const SizedBox();
      }
    }
  }
}
