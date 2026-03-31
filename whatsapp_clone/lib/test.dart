// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_trimmer/video_trimmer.dart';

// class VideoTrimPage extends StatefulWidget {
//   final String path;

//   const VideoTrimPage({super.key, required this.path});

//   @override
//   State<VideoTrimPage> createState() => _VideoTrimPageState();
// }

// class _VideoTrimPageState extends State<VideoTrimPage> {
//   final Trimmer _trimmer = Trimmer();

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadVideo();
//     log(widget.path);
//   }

//   Future<void> loadVideo() async {
//     await _trimmer.loadVideo(videoFile: File(widget.path));

//     _trimmer.videoPlayerController?.play(); // 🔥 add this

//     setState(() {
//       isLoading = false;
//     });
//   }

//   void saveVideo() async {
//     await _trimmer.saveTrimmedVideo(
//       startValue: 0.0,
//       endValue: 10.0,
//       onSave: (outputPath) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Saved: $outputPath")));
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _trimmer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Trim Video")),
//       body: Column(
//         children: [
//           Expanded(child: VideoViewer(trimmer: _trimmer)),

//           // 🔹 Trim UI
//           TrimViewer(
//             trimmer: _trimmer,
//             viewerHeight: 50,
//             viewerWidth: MediaQuery.of(context).size.width,
//           ),

//           const SizedBox(height: 20),

//           ElevatedButton(onPressed: saveVideo, child: const Text("Save Video")),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

class statusvideo extends StatefulWidget {
  final File file;
  const statusvideo({super.key, required this.file});

  @override
  State<statusvideo> createState() => _statusvideoState();
}

class _statusvideoState extends State<statusvideo> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        log(outputPath!);
        setState(() {
          _progressVisibility = false;
          _value = outputPath;
        });
      },
    );

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 10),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(backgroundColor: Colors.red),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      VideoViewer(trimmer: _trimmer),
                      Center(
                        child: TextButton(
                          child: _isPlaying
                              ? Icon(
                                  Icons.pause,
                                  size: 80.0,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.play_arrow,
                                  size: 80.0,
                                  color: Colors.white,
                                ),
                          onPressed: () async {
                            bool playbackState = await _trimmer
                                .videoPlaybackControl(
                                  startValue: _startValue,
                                  endValue: _endValue,
                                );
                            setState(() {
                              _isPlaying = playbackState;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: const Duration(seconds: 30),
                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => _endValue = value,
                    onChangePlaybackState: (value) =>
                        setState(() => _isPlaying = value),
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  onPressed: _progressVisibility
                      ? null
                      : () async {
                          _saveVideo().then((outputPath) {
                            print('OUTPUT PATH: $outputPath');
                            final snackBar = SnackBar(
                              content: Text('Video Saved successfully'),
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(snackBar);
                          });
                        },
                  child: Text(
                    "SAVE",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
