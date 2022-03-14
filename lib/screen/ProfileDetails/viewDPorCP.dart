import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';
class viewDPorCP extends StatelessWidget {
 final String? image;
 final String? title;
 final String? tag;

 viewDPorCP({this.tag,this.image,this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title!,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
      ),
      body: Hero(
        tag: tag!,
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(image!),
                  fit: BoxFit.contain)),
        ),
      ),
    );
  }
}
