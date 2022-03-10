import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CachePage extends StatefulWidget {
  final String? videoUrl;

  CachePage({this.videoUrl});

  @override
  _CachePageState createState() => _CachePageState();
}

class _CachePageState extends State<CachePage> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl!,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,
        key: "testCacheKey",
      ),
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _betterPlayerController),
            ),
            const Opacity(opacity: 0.0, child: Divider()),
            TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              icon: const Icon(
                Icons.play_arrow_sharp,
                color: Colors.white,
              ),
              label: const Text(
                "Play video",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await _betterPlayerController
                    .setupDataSource(_betterPlayerDataSource);
                await _betterPlayerController.play();
              },
            ),
          ],
        ),
      ),
    );
  }
}
