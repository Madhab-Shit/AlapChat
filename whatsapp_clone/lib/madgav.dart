import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';

class AudioWavePage extends StatefulWidget {
  const AudioWavePage({super.key});

  @override
  State<AudioWavePage> createState() => _AudioWavePageState();
}

class _AudioWavePageState extends State<AudioWavePage> {
  late RecorderController recorderController;
  late PlayerController playerController;

  String path = "";
  bool isRecording = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    recorderController = RecorderController();
    playerController = PlayerController();
  }

  startRecord() async {
    final dir = await getApplicationDocumentsDirectory();

    path = "${dir.path}/test_audio.aac";

    await recorderController.record(path: path);

    setState(() {
      isRecording = true;
    });
  }

  stopRecord() async {
    await recorderController.stop();

    setState(() {
      isRecording = false;
    });
  }

  playAudio() async {
    log(path);
    await playerController.preparePlayer(path: path);

    playerController.startPlayer();

    setState(() {
      isPlaying = true;
    });
  }

  stopAudio() async {
    playerController.stopPlayer();

    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Audio Waveforms Example")),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Recording waveform
          if (isRecording)
            AudioWaveforms(
              recorderController: recorderController,
              size: Size(MediaQuery.of(context).size.width, 100),
              waveStyle: const WaveStyle(
                waveColor: Colors.blue,
                showMiddleLine: false,
              ),
            ),

          /// Playback waveform
          if (!isRecording && path.isNotEmpty)
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width, 100),
              playerController: playerController,
            ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Record button
              ElevatedButton(
                onPressed: isRecording ? stopRecord : startRecord,
                child: Text(isRecording ? "Stop Record" : "Start Record"),
              ),

              const SizedBox(width: 20),

              /// Play button
              if (path.isNotEmpty)
                ElevatedButton(
                  onPressed: isPlaying ? stopAudio : playAudio,
                  child: Text(isPlaying ? "Stop Play" : "Play"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
