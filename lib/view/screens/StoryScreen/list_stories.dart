import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/story_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/story_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/image_config.dart';
import 'package:wave/utils/routing.dart';

class ListStories extends StatelessWidget {
  const ListStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataController>(
      builder: (context, userDataController, child) {
        return SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(left: 14.0, right: 8, top: 2),
            // color: Colors.amber.shade100,
            height: displayHeight(context) * 0.12,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<CustomResponse>(
                  future: StoryData.fetchMyStory(),
                  builder: (BuildContext context,
                      AsyncSnapshot<CustomResponse> customResSnap) {
                    if (customResSnap.connectionState == ConnectionState.done) {
                      if (customResSnap.data!.responseStatus) {
                        // Story is already present
                        Story story = (customResSnap.data!.response as Story);
                        return Column(
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.viewStoryScreen,
                                        arguments: story);
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.green.shade300,
                                    child: CircleAvatar(
                                      radius: 26.9,
                                      backgroundImage: (userDataController
                                                      .user!.displayPicture !=
                                                  null &&
                                              userDataController.user!
                                                  .displayPicture!.isNotEmpty)
                                          ? CachedNetworkImageProvider(
                                              userDataController
                                                  .user!.displayPicture!)
                                          : null,
                                      child: userDataController
                                                      .user!.displayPicture ==
                                                  null ||
                                              userDataController
                                                  .user!.displayPicture!.isEmpty
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: InkWell(
                                    onTap: () async {
                                      XFile? pickedFile =
                                          await pickMediaForStory(context);
                                      if (pickedFile != null) {
                                        Get.toNamed(AppRoutes.creatStoryScreen,
                                            arguments: pickedFile);
                                      }
                                    },
                                    child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.black,
                                        child: Icon(
                                          Icons.add,
                                          size: 13,
                                          color: Colors.white,
                                        )),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "You",
                              style: TextStyle(
                                  fontFamily: CustomFont.poppins, fontSize: 10),
                            )
                          ],
                        );
                      } else {
                        // No stories tap to create
                        return InkWell(
                          onTap: () async {
                            XFile? pickedFile =
                                await pickMediaForStory(context);
                            if (pickedFile != null) {
                              Get.toNamed(AppRoutes.creatStoryScreen,
                                  arguments: pickedFile);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 30,
                                backgroundImage:
                                    AssetImage(CustomIcon.addStoryIcon),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "You",
                                style: TextStyle(
                                    fontFamily: CustomFont.poppins,
                                    fontSize: 10),
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 30,
                            backgroundImage:
                                AssetImage(CustomIcon.addStoryIcon),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "You",
                            style: TextStyle(
                                fontFamily: CustomFont.poppins, fontSize: 10),
                          )
                        ],
                      );
                    }
                  },
                ),
                Expanded(child: Consumer<UserDataController>(
                  builder: (context, userDataController, child) {
                    if (userDataController.fetch_feed_story ==
                        FETCH_FEED_STORY.NOT_FETCHED) {
                      userDataController.fetchFeedStories();
                    }
                    switch (userDataController.fetch_feed_story) {
                      case FETCH_FEED_STORY.FETCHING:
                        return LinearProgressIndicator();
                      case FETCH_FEED_STORY.FETCHED:
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemCount: userDataController.feedStories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder<User>(
                              future: UserData.getUser(
                                  userID: userDataController.feedStories.keys
                                      .toList()[index]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<User> userSnap) {
                                if (userSnap.connectionState ==
                                    ConnectionState.done) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                                AppRoutes.viewStoryScreen,
                                                arguments: userDataController
                                                        .feedStories[
                                                    userSnap.data!.id]);
                                          },
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                Colors.green.shade300,
                                            child: CircleAvatar(
                                              radius: 26.9,
                                              backgroundImage: (userSnap.data!
                                                              .displayPicture !=
                                                          null &&
                                                      userSnap
                                                          .data!
                                                          .displayPicture!
                                                          .isNotEmpty)
                                                  ? CachedNetworkImageProvider(
                                                      userSnap.data!
                                                          .displayPicture!)
                                                  : null,
                                              child: userSnap.data!
                                                              .displayPicture ==
                                                          null ||
                                                      userSnap
                                                          .data!
                                                          .displayPicture!
                                                          .isEmpty
                                                  ? const Icon(Icons.person)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          userSnap.data!.username,
                                          style: TextStyle(
                                              fontFamily: CustomFont.poppins,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            );
                          },
                        );
                      case FETCH_FEED_STORY.NOT_FETCHED:
                        return LinearProgressIndicator();
                    }
                  },
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
