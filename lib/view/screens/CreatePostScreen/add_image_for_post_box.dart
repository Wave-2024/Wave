import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/controllers/PostController/create_post_controller.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/image_config.dart';
import 'package:wave/view/reusable_components/thumbnail_media.dart';

class AddImageForPostBox extends StatelessWidget {
  CreatePostController postController;
  AddImageForPostBox({super.key, required this.postController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: displayHeight(context) * 0.13,
      width: double.infinity,
      // color: Colors.red.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              List<XFile>? selectedMediaFile =
                  await pickMultipleMediaFiles(context);
              if (selectedMediaFile != null) {
                "adding image".printInfo();
                postController.addMediaFiles(selectedMediaFile);
              }
            },
            child: Image.asset(
              CustomIcon.addImageIcon,
              height: displayHeight(context) * 0.11,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: postController.selectedMediaFiles.length,
            itemBuilder: (context, index) {
              File file = postController.selectedMediaFiles[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                child: file.path.endsWith('.mp4')
                    ? VideoThumbnail(file: file)
                    : ImageThumbnail(file: file),
              );
            },
          )),
        ],
      ),
    );
  }
}
