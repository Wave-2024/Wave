import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wave/data/story_data.dart';
import 'package:wave/models/story_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/view/reusable_components/video_play.dart';
import 'package:wave/view/screens/StoryScreen/viewers_dialog.dart';

class ViewStoryScreen extends StatefulWidget {
  ViewStoryScreen({super.key});

  @override
  State<ViewStoryScreen> createState() => _ViewStoryScreenState();
}

class _ViewStoryScreenState extends State<ViewStoryScreen> {
  final Story story = Get.arguments['story'];
  final User storyPoster = Get.arguments['storyPoster'];

  PageController pageController = PageController();

  int currentStoryIndex = 0;

  void changeStoryIndex(int index) {
    currentStoryIndex = index;
    setState(() {});
    increaseViewCounter();
  }

  increaseViewCounter({String? subStoryId}) {
    StoryData.increaseViewCountOnStory(
        storyId: story.id,
        subStoryId: subStoryId ?? currentStoryIndex.toString(),
        userId: story.userId);
  }

  @override
  void initState() {
    super.initState();
    increaseViewCounter(subStoryId: '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
          // centerTitle: true,
          leadingWidth: 25,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: (storyPoster.displayPicture != null &&
                        storyPoster.displayPicture!.isNotEmpty)
                    ? CachedNetworkImageProvider(storyPoster.displayPicture!)
                    : null,
                radius: 18,
                child: storyPoster.displayPicture == null ||
                        storyPoster.displayPicture!.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                storyPoster.name,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: CustomFont.poppins,
                    fontSize: 15,
                    letterSpacing: 0.1),
              ),
              const SizedBox(
                width: 3,
              ),
              Visibility(
                  visible: storyPoster.verified,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Image.asset(
                      CustomIcon.verifiedIcon,
                      height: 12.2,
                    ),
                  ))
            ],
          ),
          backgroundColor: Colors.black87,
          elevation: 0,
          // toolbarHeight: kToolbarHeight + 15,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: pageController,
                onPageChanged: changeStoryIndex,
                itemCount: story.contents.length,
                itemBuilder: (context, index) {
                  if (story.contents[index].story_type == STORY_TYPE.IMAGE) {
                    return CachedNetworkImage(
                      imageUrl: story.contents[index].url,
                      fit: BoxFit.contain,
                    );
                  } else {
                    return VideoPlayerWidget(
                      url: story.contents[index].url,
                    );
                  }
                },
              ),
              Positioned(
                bottom: Get.height * 0.05,
                child: Visibility(
                  visible: story.contents.length > 1,
                  child: AnimatedSmoothIndicator(
                    activeIndex: currentStoryIndex,
                    count: story.contents.length,
                    effect: WormEffect(
                        activeDotColor: CustomColor.primaryColor,
                        dotHeight: 8,
                        dotWidth: 8),
                  ),
                ),
              ),
              Positioned(
                  bottom: Get.height * 0.042,
                  left: Get.width * 0.05,
                  child: Visibility(
                    visible: story.userId ==
                        fb.FirebaseAuth.instance.currentUser!.uid,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: ViewersDialog(
                                  viewers:
                                      story.contents[currentStoryIndex].seenBy),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              CustomIcon.viewedByIcon,
                              height: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              story.contents[currentStoryIndex].seenBy.length
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: CustomFont.inter),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
