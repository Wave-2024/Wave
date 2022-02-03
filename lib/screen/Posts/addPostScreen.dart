import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
           IconButton(
                  onPressed: () {
                   if(imagefile!=null){
                     setState(() {
                       imagefile = null;
                     });
                   }
                  },
                  color: (imagefile!=null)?Colors.red[300]:Colors.grey,
                  icon: const Icon(Icons.delete)),
          IconButton(onPressed: () {
            if(imagefile!=null){
              setState(() {
                uploadingPost = true;
              });
              Provider.of<manager>(context, listen: false)
                  .addNewPost(captionController!.text.toString(),
                  currentUser!.uid.toString(), imagefile!)
                  .then((value) {
                setState(() {
                  uploadingPost = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Successfully posted'),duration: Duration(seconds: 2),));
                Navigator.pop(context);
              });
            }
          }, icon: Icon(Icons.check),color: (imagefile!=null)?Colors.green:Colors.grey)
        ],
      ),
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: (uploadingPost!)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      Opacity(opacity: 0.0, child: Divider()),
                      Text(
                        'Uploading Post ...',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (imagefile != null)
                            ? Image.file(
                                imagefile!,
                                height: displayHeight(context) * 0.3,
                                width: displayWidth(context) * 0.6,
                                fit: BoxFit.contain,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                height: displayHeight(context) * 0.3,
                                width: displayWidth(context) * 0.6,
                                child: Center(child: IconButton(
                                  onPressed: () {
                                    pickImage();
                                  },
                                  icon: Icon(Icons.image),
                                    )),
                              ),
                        Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.1,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
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
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
