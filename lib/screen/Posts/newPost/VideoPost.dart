import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/providers/screenIndexProvider.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../utils/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  User? currentUser;
  TextEditingController? captionController;
  VideoPlayerController? _videoController;

  bool? uploadingPost;

  File? videoFile;

  final picker = ImagePicker();

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    super.initState();
    captionController = TextEditingController();
    uploadingPost = false;
  }

  @override
  void dispose() {
    _videoController!.dispose();
    captionController!.dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        videoFile = File(pickedFile.path);
      });

      _videoController = VideoPlayerController.file(videoFile!)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((value) => _videoController!.play());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('New Post', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: (uploadingPost!)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: displayHeight(context) * 0.2),
                  Expanded(child: Image.asset('images/postLoad.gif')),
                  Expanded(
                    child: Text(
                      'Uploading Post ...',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: displayWidth(context) * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.red,
                        //height: displayHeight(context) * 0.4,
                        //width: displayWidth(context),
                        child: (_videoController != null)
                            ? AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!))
                            : const Center(
                                child: Text('Upload Video'),
                              ),
                      ),
                    ),
                    Opacity(
                      child: Divider(
                        height: displayHeight(context) * 0.04,
                      ),
                      opacity: 0.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          maxLength: 500,
                          maxLines: 5,
                          minLines: 1,
                          controller: captionController,
                          decoration: const InputDecoration(
                              hintText: "Write something about the video ...",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: pickVideo,
                      label: const Text('Add Video',
                          style: TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.video_call, color: Colors.white),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.indigoAccent),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          shadowColor:
                              MaterialStateProperty.all(Colors.black54),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10.0))),
                    ),
                    const Opacity(opacity: 0.0, child: Divider()),
                    TextButton.icon(
                      onPressed: () async {
                        if (videoFile != null) {
                          setState(() {
                            uploadingPost = true;
                            _videoController!.pause();
                          });
                          await Provider.of<manager>(context, listen: false)
                              .newVideoPost(captionController!.text.toString(),
                                  currentUser!.uid, videoFile!);
                          setState(() {
                            uploadingPost = false;
                          });
                          Navigator.pop(context);
                          Provider.of<screenIndexProvider>(context,
                                  listen: false)
                              .updateIndex(4);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Post Successfull')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please upload a video')));
                        }
                      },
                      label: const Text('Submit Post',
                          style: TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.check, color: Colors.white),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange[600]),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          shadowColor:
                              MaterialStateProperty.all(Colors.black54),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(8.0))),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
