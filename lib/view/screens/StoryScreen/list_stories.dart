import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/image_config.dart';
import 'package:wave/utils/routing.dart';

class ListStories extends StatelessWidget {
  const ListStories({super.key});

  @override
  Widget build(BuildContext context) {
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
            InkWell(
              onTap: () async {
                XFile? pickedFile = await pickMediaForStory(context);
                if (pickedFile != null) {
                  Get.toNamed(AppRoutes.creatStoryScreen,arguments: pickedFile);
                }
              },
              child: Column(
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
                    style:
                        TextStyle(fontFamily: CustomFont.poppins, fontSize: 10),
                  )
                ],
              ),
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
                              fontFamily: CustomFont.poppins, fontSize: 10),
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
    );
  }
}
