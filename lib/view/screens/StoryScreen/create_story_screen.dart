import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/data/story_data.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/view/reusable_components/video_play.dart';

class CreateStoryScreen extends StatefulWidget {
  CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final XFile mediaFile = Get.arguments;

  bool isDeciding = true;
  String fileType = 'other';
  STORY_TYPE story_type = STORY_TYPE.IMAGE;

  @override
  void initState() {
    super.initState();
    decideTypeOfMedia();
  }

  void decideTypeOfMedia() {
    String fileName = mediaFile.path.split('/').last;
    String fileExtension = fileName.split('.').last.toLowerCase();
    fileType = PostData.getFileType(fileExtension);
    if (fileType == 'image') {
      story_type = STORY_TYPE.IMAGE;
    } else {
      story_type = STORY_TYPE.VIDEO;
    }
    isDeciding = false;
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Discard Story?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: CustomFont.inter,
              ),
            ),
            content: Text(
              'Do you want to discard the selected story and go back?',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontFamily: CustomFont.poppins),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: CustomFont.poppins,
                      color: Colors.black87),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontFamily: CustomFont.poppins,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text(
            "Create Story",
            style: TextStyle(
              color: Colors.white,
              fontFamily: CustomFont.poppins,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.black87,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: Consumer<UserDataController>(
          builder: (context, userDataController, child) {
            return Container(
              alignment: Alignment.center,
              height: Get.height * 0.08,
              width: Get.width,
              // color: Colors.red,
              child: userDataController.isUploadingStory
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : InkWell(
                      onTap: () async {
                        userDataController.startUploadingStory();
                        CustomResponse customResponse =
                            await StoryData.createStory(File(mediaFile.path),
                                story_type, userDataController.user!.id);
                        if (customResponse.responseStatus) {
                          'Success in story uploading'.printInfo();
                        } else {
                          customResponse.response.printError();
                        }
                        userDataController.finishUploadingStory();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Finish",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: CustomFont.poppins,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
        body: isDeciding
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Container(
                  alignment: Alignment.center,
                  height: Get.height - kBottomNavigationBarHeight,
                  width: Get.width,
                  // color: Colors.amber.shade100,
                  child: (fileType == 'image')
                      ? Image.file(
                          File(mediaFile.path),
                          fit: BoxFit.contain,
                        )
                      : (fileType == 'video')
                          ? VideoPlayerWidget(videoFile: File(mediaFile.path))
                          : SizedBox(
                              child: Text("Invalid file type"),
                            ),
                ),
              ),
      ),
    );
  }
}
