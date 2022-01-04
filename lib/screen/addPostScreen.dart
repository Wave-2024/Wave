import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

class addPostScreen extends StatefulWidget {
  @override
  State<addPostScreen> createState() => _addPostScreenState();
}

class _addPostScreenState extends State<addPostScreen> {
  File? imagefile;
  bool? uploadingPost;
  final picker = ImagePicker();
  TextEditingController? captionController;
  User? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadingPost = false;
    currentUser = FirebaseAuth.instance.currentUser;
    captionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (mounted) {
        setState(() {
          imagefile = File(pickedFile!.path);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'New Post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.1,
          ),
        ),
        actions: [
          (imagefile != null)
              ? IconButton(
                  onPressed: () {
                    PostModel post = PostModel(
                        caption: captionController!.text.toString(),
                        image: '',
                        comments: [],
                        uid: currentUser!.uid.toString(),
                        post_id: '',
                        likes: []);
                    Provider.of<usersProvider>(context, listen: false)
                        .addNewPostTest(post, currentUser!.uid.toString())
                        .then((value) {
                      print('Done');
                    });
                  },
                  color: Colors.green,
                  icon: const Icon(Icons.check))
              : IconButton(
                  onPressed: () {
                    pickImage();
                  },
                  color: Colors.indigo,
                  icon: const Icon(Icons.add_a_photo))
        ],
      ),
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (imagefile != null)
                      ? Image.file(
                          imagefile!,
                          height: displayHeight(context) * 0.3,
                          width: displayWidth(context) * 0.6,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          height: displayHeight(context) * 0.3,
                          width: displayWidth(context) * 0.6,
                          child: const Center(child: Icon(Icons.image)),
                        ),
                  Opacity(
                      opacity: 0.0,
                      child: Divider(
                        height: displayHeight(context) * 0.1,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLength: 500,
                      maxLines: 5,
                      minLines: 1,
                      controller: captionController,
                      decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
