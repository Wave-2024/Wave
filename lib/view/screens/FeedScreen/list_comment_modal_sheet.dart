import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/models/comment_post_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/database.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/view/reusable_components/custom_textbox_for_comment.dart';

class ListCommentsScreen extends StatefulWidget {
  const ListCommentsScreen({super.key});

  @override
  State<ListCommentsScreen> createState() => _ListCommentsScreenState();
}

class _ListCommentsScreenState extends State<ListCommentsScreen> {

  String? postId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postId = Get.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(
            fontFamily: CustomFont.poppins,
            fontSize: 16.5,
            letterSpacing: -0.1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: CustomColor.primaryBackGround,
      ),
      body: SafeArea(
        child: Container(
          child: CustomTextBoxForComments(
            sendWidget: Icon(Icons.add),
            sendButtonMethod: (){},
            userImage: CachedNetworkImageProvider("https://i.pinimg.com/236x/98/53/22/98532233a2efcc3b75bb544608c2e99c.jpg"),
            labelText: "label",
            child: StreamBuilder(
              stream: Database.getPostCommentsDatabase(postId!).snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> comments) {
                if ((comments.connectionState == ConnectionState.active ||
                    comments.connectionState == ConnectionState.done) &&
                    comments.hasData) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Text("Hii");
                    },);
                }
                else{
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        )
      ),
    );
  }
}
