import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';
class postDetailScreen extends StatefulWidget {
  final String? postId;
  final NexusUser? user;
  postDetailScreen({this.postId,this.user});

  @override
  State<postDetailScreen> createState() => _postDetailScreenState();
}

class _postDetailScreenState extends State<postDetailScreen> {
  @override
  Widget build(BuildContext context) {
    PostModel? postDetail = Provider.of<usersProvider>(context).fetchThisPostDetails(widget.postId!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments',style: const TextStyle(
          color: Colors.black
        ),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),

      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.user!.dp,height: displayHeight(context)*0.06,
                      width: displayWidth(context)*0.12,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const VerticalDivider(),
                  Text(widget.user!.username,style: TextStyle(
                    fontSize: displayWidth(context)*0.045,
                    color: Colors.indigoAccent,fontWeight: FontWeight.bold
                  ),),
                ],
              ),
              const Opacity(opacity:0.0,child: Divider()),
            Container(
              child: Text(postDetail!.caption,
                textAlign: TextAlign.start,
                style: TextStyle(
                fontSize: displayWidth(context)*0.036,
                color: Colors.black87
              ),),
            ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
