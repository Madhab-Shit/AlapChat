import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:traychat/controller/voicechat.dart';
import 'package:traychat/galleryacess.dart';
Voicechat voicecontroller = Get.put(Voicechat());
class chatcontroller extends GetxController {
  
  RxBool chat = false.obs;

  RxBool voice = false.obs;
  RxInt countvoice = 0.obs;
  Timer? time;
  var pickedImage = Rxn<File>();
  RxString imapedata = "".obs;


  bool isListening = false;
  String text = "";

  RxBool playpush = false.obs;
  RxInt playindes = 0.obs;
  late File file;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void timer() {
    time = Timer.periodic(Duration(seconds: 1), (time) {
      countvoice++;
    });
  }

  String getChatId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return user1 + "_" + user2;
    } else {
      return user2 + "_" + user1;
    }
  }

  void chatdata(String send, String recivers, String sms) async {
    String chatId = getChatId(send, recivers);
    await _firestore.collection('chatdata').doc(chatId).set({
      'lastMessage': sms,
      'sender': send,
      'receiver': chatId,
      'time': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore.collection('chatdata').doc(chatId).collection(chatId).add({
      'type': 'text',
      'message': sms,
      'time': FieldValue.serverTimestamp(),
      'sender': send,
      'receiver': recivers,
    });
  }

  //voice chat
  // void voicechat(
  //   String send,
  //   String recivers,
  //   String sms,
  //   String voicetime,
  // ) async {
  //   String chatId = getChatId(send, recivers);
  //   await _firestore.collection('chatdata').doc(chatId).set({
  //     'lastMessage': sms,
  //     'sender': send,
  //     'receiver': chatId,
  //     'time': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));

  //   await _firestore.collection('chatdata').doc(chatId).collection(chatId).add({
  //     'type': 'Voice',
  //     'voicetime': voicetime,
  //     'message': sms,
  //     'time': FieldValue.serverTimestamp(),
  //     'sender': send,
  //     'receiver': recivers,
  //   });
  // }

  Future<void> chatimage(String send, String recivers, String imageurl) async {
    try {
      String chatId = getChatId(send, recivers);

      await _firestore.collection('chatdata').doc(chatId).set({
        'lastMessage': "sms",
        'sender': send,
        'receiver': chatId,
        'time': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await _firestore
          .collection('chatdata')
          .doc(chatId)
          .collection(chatId)
          .add({
            'type': 'image',
            'message': imageurl,
            'time': FieldValue.serverTimestamp(),
            'sender': send,
            'receiver': recivers,
          });
    } catch (e) {
      // Jodi error ekhono hoy, check korun Firebase Rules-e 'write' permission ache kina
      log("UPLOAD ERROR: $e");
    }
  }

  //image decode

  Stream<QuerySnapshot> showmessage(String send, String recivers) {
    String showid = getChatId(send, recivers);
    return _firestore
        .collection('chatdata')
        .doc(showid)
        .collection(showid)
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> recentprofile() {
    return _firestore.collection('chatdata').snapshots();
  }

  //image picker
  Future<void> pickImage(
    BuildContext context,
    String myid,
    String otherid,
  ) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      file = File(image.path);

      Get.to(() => GalleryPickerPage(myid: myid, otherid: otherid,));
    }
  }

  //upload image cloudinary

  Future<String?> uploadImage(File file) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/dfofmcmgt/image/upload",
      );

      final request = http.MultipartRequest("POST", url)
        ..fields["upload_preset"] = "chatphoto"
        ..files.add(await http.MultipartFile.fromPath("file", file.path));

      final response = await request.send();

      final responseData = await response.stream.bytesToString();

      final data = jsonDecode(responseData);

      return data["secure_url"];
    } catch (e) {
      print(e);
      return null;
    }
  }

  //speetch voice
  // void startListening() async {
  //   bool available = await speech.initialize();

  //   if (available) {
  //     isListening = true;
  //     update();

  //     speech.listen(
  //       onResult: (result) {
  //         text = result.recognizedWords;
  //         update();
  //       },

  //       // onSoundLevelChange: (level) {

  //       // },
  //     );
  //   }
  // }

  // void stopListening(String myid, String otherid) {
  //   if (countvoice.value == 0 || text == "") {
  //     isListening = false;
  //     countvoice.value = 0;
  //     return;
  //   }
  //   log(text);

  //   speech.stop();
  //   voicechat(myid, otherid, text, countvoice.string);
  //   log(countvoice.toString());
  //   log(text);
  //   isListening = false;
  //   countvoice.value = 0;
  // }



  // final player = AudioPlayer();

  // Future playAudio(String url) async {
  //   await player.setUrl(url);
  //   player.play();
  // }

  // void pauseAudio() {
  //   player.pause();
  // }

  RxDouble lineardata = 0.0.obs;
  RxInt playingIndex = (-1).obs;

  Timer? settime;

  void linearprogre(String voicetime, int index) {
    playingIndex.value = index;

    int duration = int.parse(voicetime);
    double step = 1 / duration;

    int count = 0;

    lineardata.value = 0.0;

    settime?.cancel();

    settime = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count < duration) {
        lineardata.value += step;
        count++;
      } else {
        timer.cancel();
        lineardata.value = 0.0;
        playingIndex.value = -1;
        playpush.value = false;
      }
    });
  }
}
