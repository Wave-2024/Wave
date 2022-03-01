import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';
class fullScreenImage extends StatelessWidget {
  final String? image;
  final String? postId;
  fullScreenImage({this.image,this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
      ),
      body: Hero(
        tag: postId!,
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: CachedNetworkImageProvider(image!),fit: BoxFit.contain
            )
          ),
        ),
      ),
    );
  }
}
