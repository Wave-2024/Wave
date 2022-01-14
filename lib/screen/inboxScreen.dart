import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';

class inboxScreen extends StatelessWidget {
  String ?chatId;
  NexusUser? thisUser,myProfile;
  inboxScreen({this.myProfile,this.thisUser,this.chatId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black,),
        title: Text(thisUser!.username,style: TextStyle(color: Colors.black),),
      ),
      body: Container(

      ),
    );
  }
}
