import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/providers/screenIndexProvider.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

class TextPost extends StatefulWidget {
  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  TextEditingController? captionController;
  User? currentUser;
  bool? uploadingPost;

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
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('New Post', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        color: Colors.white,
        height: displayHeight(context),
        width: displayWidth(context),
        padding: const EdgeInsets.all(36),
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
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 12,
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
                    TextButton(
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
                                const EdgeInsets.all(6.0))),
                        onPressed: () async {
                          if (captionController!.text.isNotEmpty) {
                            setState(() {
                              uploadingPost = true;
                            });
                            await Provider.of<manager>(context, listen: false)
                                .newTextPost(captionController!.text.toString(),
                                    currentUser!.uid);
                            setState(() {
                              uploadingPost = false;
                            });
                            Navigator.pop(context);
                            Provider.of<screenIndexProvider>(context,
                                    listen: false)
                                .updateIndex(4);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Successfully posted')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Post cannot be empty.')));
                          }
                        },
                        child: const Text(
                          'Submit Post',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ),
      ),
    );
  }
}
