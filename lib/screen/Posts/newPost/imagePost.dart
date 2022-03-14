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

class imagePost extends StatefulWidget {
  @override
  State<imagePost> createState() => _imagePostState();
}

class _imagePostState extends State<imagePost> {
  TextEditingController? captionController;
  User? currentUser;
  bool? uploadingPost;
  File? imageFile;
  final picker = ImagePicker();

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<File> checkAnCompress() async {
    File? compressedFile = imageFile!;
    int minimumSize = 200 * 1024;
    if (await compressedFile.length() > minimumSize) {
      final dir = await path_provider.getTemporaryDirectory();
      final tp = dir.absolute.path + "/temp.jpg";
      compressedFile = await compressAndGetFile(compressedFile, tp);
    }
    return compressedFile;
  }

  @override
  void initState() {
    uploadingPost = false;
    currentUser = FirebaseAuth.instance.currentUser;
    captionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    captionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (imageFile != null) {
                  _cropImage();
                }
              },
              icon: const Icon(Icons.crop))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('New Post', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
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
                padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: (imageFile != null)
                          ? Image.file(
                              imageFile!,
                              fit: BoxFit.contain,
                            )
                          : const Center(
                              child: Text(
                                'No image selected',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                    )),
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
                              hintText: "Write a caption...",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: pickImage,
                      label: const Text('Add Image',
                          style: TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.add_a_photo, color: Colors.white),
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
                        if (imageFile != null) {
                          setState(() {
                            uploadingPost = true;
                          });
                          await Provider.of<manager>(context, listen: false)
                              .newImagePost(captionController!.text.toString(),
                                  currentUser!.uid, imageFile!);
                          setState(() {
                            uploadingPost = false;
                          });
                          Navigator.pop(context);
                          Provider.of<screenIndexProvider>(context,
                                  listen: false)
                              .updateIndex(4);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Post Successfull')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Please upload an image')));
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
