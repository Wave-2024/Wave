import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  ViewImage({super.key});

  final String url = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: PhotoView(
          enableRotation: true,
          imageProvider: CachedNetworkImageProvider(url),
        ),
      )),
    );
  }
}
