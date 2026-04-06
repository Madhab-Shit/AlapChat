import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:traychat/chat.dart';
import 'package:traychat/controller/chatcontroller.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/controller/statuscontroller.dart';
import 'package:video_player/video_player.dart';

class Mystoryplay extends StatefulWidget {
  final String item;
  final time;
  final int index;
  final String username;
  const Mystoryplay({
    super.key,
    required this.item,
    required this.time,
    required this.index,
    required this.username,
  });

  @override
  _MystoryplayState createState() => _MystoryplayState();
}

class _MystoryplayState extends State<Mystoryplay> {
  final Getx controller = Get.find<Getx>();
  final Chatcontroller date = Get.find<Chatcontroller>();
  final Statuscontroller status = Get.find<Statuscontroller>();
  int i = 0;
  late VideoPlayerController _controller;
  String day = '';

  @override
  void initState() {
    super.initState();
    loadVideo();
    chat.timefind(widget.time);
    datefind();
  }

  void datefind() {
    chat.todayfind();
    if (chat.formattedTime.value.split(',').first ==
        chat.date.value.split(',').first) {
      day = 'today';
    } else {
      day = 'Yesterday';
    }
  }

  void loadVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.item))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(videoListener);
  }

  void videoListener() {
    if (_controller.value.position >= _controller.value.duration &&
        !_controller.value.isPlaying) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          spacing: 10,
          children: [
            CircleAvatar(
              child: Text(controller.username.value.toString().split('').first),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "My Status",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Text(
                  "${day} ${date.formattedTime.value.split(',').last}",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PopupMenuButton(
              onSelected: (value) async {
                if (value == 'Delete') {
                  status.deletestatus(widget.username, widget.index);

                  Get.back();
                } else if (value == 'Share') {
                  SharePlus.instance.share(ShareParams(text: "${widget.item}"));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(child: Text("Share"), value: "Share"),
                PopupMenuItem(child: Text("Delete"), value: "Delete"),
              ],
              child: Icon(Icons.more_vert_sharp, color: Colors.white),
            ),
          ),
        ],
      ),
      body: InkWell(
        onTap: () {
          Get.back();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
