import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    decideTypeOfMedia();
  }

  void decideTypeOfMedia() {
    String fileName = mediaFile.path.split('/').last;
    String fileExtension = fileName.split('.').last.toLowerCase();
    fileType = PostData.getFileType(fileExtension);
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
        bottomNavigationBar: Container(
          alignment: Alignment.center,
          height: Get.height * 0.08,
          width: Get.width,
          // color: Colors.red,
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
