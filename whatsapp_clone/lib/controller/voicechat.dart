import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:traychat/chat.dart';

class Voicechat extends GetxController {
  late RecorderController recorderController;
  late PlayerController playerController;

  String recordPath = "";
  bool isRecording = false;
  bool isPlaying = false;

  RxInt totalDuration = 0.obs;
  RxInt currentDuration = 0.obs;
  RxInt playingIndex = (-1).obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    recorderController = RecorderController();
    playerController = PlayerController();
  }

  // ================= CHAT ID =================

  String getChatId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "${user1}_$user2";
    } else {
      return "${user2}_$user1";
    }
  }

  // ================= START RECORD =================

  Future<void> startRecord() async {
    log("Start");
    final dir = await getApplicationDocumentsDirectory();

    recordPath =
        "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac";

    await recorderController.record(path: recordPath);

    isRecording = true;
    update();
  }

  // ================= STOP RECORD =================

  Future<void> stopRecord(String myId, String otherId) async {
    await recorderController.stop();

    isRecording = false;
    update();

    final file = File(recordPath);

    if (file.existsSync()) {
      final url = await uploadAudio(file);

      if (url != null) {
        await sendVoiceMessage(myId, otherId, url);
      } else {
        log("UPLOAD FAILED");
      }
    }
  }

  // ================= CLOUDINARY UPLOAD =================

  Future<String?> uploadAudio(File file) async {
    try {
      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/dfofmcmgt/video/upload",
      );

      final request = http.MultipartRequest("POST", uri)
        ..fields["upload_preset"] = "audioPlay"
        ..files.add(await http.MultipartFile.fromPath("file", file.path));

      final response = await request.send();

      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseString);
        return data["secure_url"];
      } else {
        return null;
      }
    } catch (e) {
      log("UPLOAD ERROR = $e");
      return null;
    }
  }

  // ================= SEND FIRESTORE =================

  Future<void> sendVoiceMessage(
    String senderId,
    String receiverId,
    String voiceUrl,
  ) async {
    try {
      String chatId = getChatId(senderId, receiverId);

      final total = Duration(milliseconds: totalDuration.value);
      String t =
          "${total.inMinutes}:${(total.inSeconds % 60).toString().padLeft(2, '0')}";

      log(t.toString());

      await _firestore.collection('chatdata').doc(chatId).set({
        'lastMessage': "voice",
        'sender': senderId,
        'receiver': chatId,
        'time': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await _firestore
          .collection('chatdata')
          .doc(chatId)
          .collection(chatId)
          .add({
            'type': 'voice',
            'message': voiceUrl,
            'time': FieldValue.serverTimestamp(),
            'sender': senderId,
            'receiver': receiverId,
            'voicetime': chat.countvoice.value,
          });
    } catch (e) {
      // Jodi error ekhono hoy, check korun Firebase Rules-e 'write' permission ache kina
      log("UPLOAD ERROR: $e");
    }
  }

  Future<void> playAudio(String url, int index) async {
    // যদি নতুন index হয় → আগে stop
    if (playingIndex.value != index) {
      await playerController.stopPlayer();
    }

    playingIndex.value = index;

    await playerController.preparePlayer(
      path: url,
      shouldExtractWaveform: false,
    );

    playerController.startPlayer();
  }

  // ================= STOP AUDIO =================

  Future<void> stopAudio() async {
    await playerController.stopPlayer();
    isPlaying = false;
    update();
  }
}
