import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://res.cloudinary.com/dfofmcmgt/video/upload/v1774975566/fjdlnz1ighzshjf8vf4g.mp4',
            ),
          )
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });

    // 🔥 LISTENER
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        print("Video Finished ✅");

        // 👉 এখানে তুমি যা খুশি করতে পারো
        // example:
        Get.back();
        // next video play
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
