import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/story/controller/controller.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final List item;
  final String name;
  const VideoApp({super.key, required this.item, required this.name});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  final sorycontroler story = Get.put(sorycontroler());
  final Getx chatcon = Get.find<Getx>();
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

  void nextVideo() async {
    _controller.removeListener(videoListener);
    _controller.dispose();

    i++;

    if (i >= widget.item.length) {
      story.viewcount(widget.name, chatcon.username.value, i - 1);
      Get.back();
      return;
    }
    story.viewcount(widget.name, chatcon.username.value, i - 1);

    loadVideo();
  }

  void Prevvideo() {
    _controller.removeListener(videoListener);
    _controller.dispose();

    i--;

    if (i < 0) {
      // Get.back();
      i++;
      loadVideo();
      return;
    }

    loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(widget.name, style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Prevvideo();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  width: 120,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              InkWell(
                onTap: () {
                  nextVideo();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  width: 120,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
