import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import '../../providers/manager.dart';

class uploadImageScreen extends StatefulWidget {
  String? imageType;
  File? originalFile;
  uploadImageScreen({this.imageType, this.originalFile});

  @override
  State<uploadImageScreen> createState() => _uploadImageScreenState();
}

class _uploadImageScreenState extends State<uploadImageScreen> {
  bool? isProcessing;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: toCrop!.path,
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
        toCrop = croppedFile;
      });
    }
  }

  Future<File> checkAnCompress() async {
    File? compressedFile = toCrop!;
    int minimumSize = 200 * 1024;
    if (await compressedFile.length() > minimumSize) {
      final dir = await path_provider.getTemporaryDirectory();
      final tp = dir.absolute.path + "/temp.jpg";
      compressedFile = await compressAndGetFile(compressedFile, tp);
    }
    return compressedFile;
  }

  File? toCrop;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toCrop = widget.originalFile;
    isProcessing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (cnt) {
                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.file(
                              toCrop!,
                              height: displayHeight(context) * 0.06,
                              width: displayWidth(context) * 0.12,
                              fit: BoxFit.cover,
                            ),
                            const Opacity(
                              child: VerticalDivider(),
                              opacity: 0.0,
                            ),
                             (widget.imageType=="DP")?const Text("Set Profile Picture"):const Text("Set Cover Photo"),
                          ],
                        ),
                        content: (widget.imageType=="DP")? const Text(
                            "Are you sure you want to set this as your new profile picture ?"):const Text('Are you sure you want to set this as your new cover photo ?'),
                        actions: [
                          TextButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red[600]),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.black87),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(2.0))),
                              onPressed: () => Navigator.pop(cnt),
                              child: const Text(
                                'NO',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextButton(
                              child: const Text(
                                'YES',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.black54),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(4.0))),
                              onPressed: () async {
                                setState(() {
                                  isProcessing = true;
                                  Navigator.pop(cnt);
                                });
                                File? compressedFile = await checkAnCompress();
                                (widget.imageType == "DP")
                                    ? await Provider.of<manager>(context,
                                            listen: false)
                                        .addProfilePicture(compressedFile,
                                            currentUser!.uid.toString())
                                        .then((value) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    " Profile picture updated")));
                                      })
                                    : await Provider.of<manager>(context,
                                            listen: false)
                                        .addCoverPicture(compressedFile,
                                            currentUser!.uid.toString())
                                        .then((value) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Cover photo updated')));
                                      });
                              },
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.upload,
                color: Colors.black,
              ))
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'Crop',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: (isProcessing!)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: displayHeight(context) * 0.2,
                  ),
                  Expanded(child: Image.asset('images/uploadPost.gif')),
                  Expanded(
                    child: Text(
                      'Uploading image',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.05),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                      flex: 5,
                      child: (toCrop != null)
                          ? Image.file(toCrop!)
                          : const CircularProgressIndicator()),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              toCrop = widget.originalFile;
                            });
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(5),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.indigoAccent),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.black54),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(14.0))),
                          child: const Text(
                            'Original Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Opacity(
                            opacity: 0.0,
                            child: VerticalDivider(
                              width: displayWidth(context) * 0.1,
                            )),
                        TextButton.icon(
                            icon: const Icon(
                              Icons.crop,
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.orange[600]),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.black54),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(10.0))),
                            onPressed: _cropImage,
                            label: Text('Crop image',
                                style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
