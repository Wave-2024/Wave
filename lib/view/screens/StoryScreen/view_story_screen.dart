import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wave/data/story_data.dart';
import 'package:wave/models/story_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/view/reusable_components/video_play.dart';

class ViewStoryScreen extends StatefulWidget {
  ViewStoryScreen({super.key});

  @override
  State<ViewStoryScreen> createState() => _ViewStoryScreenState();
}

class _ViewStoryScreenState extends State<ViewStoryScreen> {
  final Story story = Get.arguments;

  PageController pageController = PageController();

  int currentStoryIndex = 0;

  void changeStoryIndex(int index) {
    currentStoryIndex = index;
    setState(() {});
    increaseViewCounter();
  }

  increaseViewCounter() {
    StoryData.increaseViewCountOnStory(
        storyId: story.id,
        subStoryId: currentStoryIndex.toString(),
        userId: story.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
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
                    visible:
                        story.userId == FirebaseAuth.instance.currentUser!.uid,
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
                  ))
            ],
          ),
        ));
  }
}
