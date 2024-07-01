import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String? url;
  final File? videoFile;
  const VideoPlayerWidget({Key? key, this.url, this.videoFile})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.url != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!));
    } else {
      _controller = VideoPlayerController.file(widget.videoFile!);
    }
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(2.0);
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
          'connecttin established'.printInfo();
          _controller.dataSource.printInfo();
          _controller.value.aspectRatio.printInfo();
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                ControlsOverlay(controller: _controller),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                      playedColor: Colors.green,
                      bufferedColor: Colors.green.shade200),
                ),
              ],
            ),
          );
        } else {
          'connecttin ot established'.printInfo();

          return const Center(
              child: CircularProgressIndicator(
            color: Colors.pink,
          ));
        }
      },
    );
  }
}

class ControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;

  const ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  @override
  _ControlsOverlayState createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      AntDesign.play_circle_outline,
                      color: Colors.white54,
                      size: 35.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.controller.value.isPlaying
                  ? widget.controller.pause()
                  : widget.controller.play();
            });
          },
        ),
      ],
    );
  }
}
