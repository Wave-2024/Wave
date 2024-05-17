import 'package:flutter/material.dart';
import 'package:wave/models/post_content_model.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/view/reusable_components/feedbox.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14, top: 10),
              child: Text(
                "Wave",
                style: TextStyle(fontFamily: CustomFont.alex, fontSize: 40),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 14.0, right: 8, top: 2),
              // color: Colors.amber.shade100,
              height: displayHeight(context) * 0.12,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 30,
                        backgroundImage: AssetImage(CustomIcon.addStoryIcon),
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
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.blue.shade100,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "alpha3109",
                                style: TextStyle(
                                    fontFamily: CustomFont.poppins,
                                    fontSize: 10),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            FeedBox(
                post: Post(
                    id: "id",
                    postList: [
                      PostContent(
                          type: "image",
                          url:
                              "https://i.pinimg.com/564x/ff/24/ea/ff24ea91497d0f4d754d41d9cf42eded.jpg"),
                      PostContent(
                          type: "image",
                          url:
                              "https://i.pinimg.com/564x/57/a7/2a/57a72a5c8fbf79751d703ae2d6a3a064.jpg"),
                      PostContent(
                          type: "image",
                          url:
                              "https://i.pinimg.com/564x/34/09/3f/34093f12f08c076173c552b62718c50f.jpg"),
                      PostContent(
                          type: "image",
                          url:
                              "https://i.pinimg.com/564x/b8/de/d2/b8ded21f1c58ce939b37145edf3ddd47.jpg"),
                      PostContent(
                          type: "image",
                          url:
                              "https://i.pinimg.com/564x/ea/ec/83/eaec837884aa2825ac3359cc5ffeb65d.jpg")
                    ],
                    createdAt: DateTime.now(),
                    userId: "userId",
                    caption:
                        "hello this is a dummy post and i am subhojeet sahoo This example ensures that the RichText widget wraps and does not overflow from its container. Adjust the width and padding as needed for your specific layout.",
                    mentions: [])),
          ],
        ),
      )),
    );
  }
}
