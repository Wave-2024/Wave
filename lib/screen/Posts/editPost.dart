import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/ProfileDetails/editProfile.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';
class editPostScreen extends StatefulWidget {
  final PostModel? post;
  editPostScreen({this.post});

  @override
  State<editPostScreen> createState() => _editPostScreenState();
}

class _editPostScreenState extends State<editPostScreen> {
  TextEditingController? captionController;
  User? currentUser;
  final formKey = GlobalKey<State>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    captionController = TextEditingController(text: widget.post!.caption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Edit',style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: () {
            Provider.of<manager>(context,listen: false).updateCaption(currentUser!.uid, widget.post!.post_id, captionController!.text.toString());
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post updated successfully")));
            Navigator.pop(context);
          }, icon: Icon(Icons.check),
          color: Colors.orange
          )
        ],
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
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
    );
  }
}
