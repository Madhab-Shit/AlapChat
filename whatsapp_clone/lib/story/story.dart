import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final List item;
  const VideoApp({super.key, required this.item});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  int i = 0;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  void loadVideo() {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.item[i]['video']))
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });

    _controller.addListener(videoListener);
  }

  void videoListener() {
    if (_controller.value.position >= _controller.value.duration &&
        !_controller.value.isPlaying) {
      nextVideo();
    }
  }

  void nextVideo() {
    _controller.removeListener(videoListener);
    _controller.dispose();

    i++;

    if (i >= widget.item.length) {
      Get.back();
      return;
    }

    loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
