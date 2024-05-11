import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wave/utils/device_size.dart';

class ImageThumbnail extends StatelessWidget {
  final File file;

  ImageThumbnail({required this.file});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.file(file,
          height: displayHeight(context) * 0.11,
          width: displayWidth(context) * 0.23,
          fit: BoxFit.cover),
    );
  }
}

class VideoThumbnail extends StatefulWidget {
  final File file;

  VideoThumbnail({required this.file});

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: displayHeight(context) * 0.11,
            width: displayWidth(context) * 0.23,
            //aspectRatio: _controller.value.aspectRatio,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: VideoPlayer(_controller)),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
