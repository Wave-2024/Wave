import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class uploadStoryScreen extends StatefulWidget {
  final File? imageFile;

  uploadStoryScreen({this.imageFile});

  @override
  State<uploadStoryScreen> createState() => _uploadStoryScreenState();
}

class _uploadStoryScreenState extends State<uploadStoryScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool? isUploading;

  @override
  void initState() {
    super.initState();
    isUploading = false;
  }

  loadingBoxDecoration() {
    return const BoxDecoration(color: Colors.white);
  }

  normalBoxDecoration() {
    return BoxDecoration(
      image: DecorationImage(
          image: FileImage(widget.imageFile!), fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        decoration:
            (isUploading!) ? loadingBoxDecoration() : normalBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (isUploading!)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: displayHeight(context) * 0.2),
                    Expanded(child: Image.asset('images/uploadStory.gif')),
                    Expanded(
                      child: Text(
                        'Updating your story',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: displayWidth(context) * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: displayWidth(context) * 0.06,
                          backgroundColor: Colors.black87,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.white70,
                                iconSize: displayWidth(context) * 0.05,
                                icon: Icon(Icons.arrow_back_ios)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isUploading = true;
                            });
                            await Provider.of<manager>(context, listen: false)
                                .addStoryToServer(
                                    currentUser!.uid, widget.imageFile!);
                            setState(() {
                              isUploading = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Card(
                            color: Colors.black87,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                child: Text(
                                  'Set Story',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: displayWidth(context) * 0.036,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
        ),
      ),
    ));
  }
}
