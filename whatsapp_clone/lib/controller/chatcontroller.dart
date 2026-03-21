import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
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

      Get.to(() => GalleryPickerPage(myid: myid, otherid: otherid));
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
      return null;
    }
  }

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

  Future<void> pickAndViewFile(String myid, String otherid) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      for (int i = 0; i < files.length; i++) {
        try {
          final url = Uri.parse(
            "https://api.cloudinary.com/v1_1/dfofmcmgt/image/upload",
          );

          final request = http.MultipartRequest("POST", url)
            ..fields["upload_preset"] = "document"
            ..files.add(
              await http.MultipartFile.fromPath("file", files[i].path),
            );

          final response = await request.send();

          final responseData = await response.stream.bytesToString();

          final data = jsonDecode(responseData);

          log(data["secure_url"]);
          uploadocument(myid, otherid, data["secure_url"]);
        } catch (e) {
          return;
        }
      }
    }
  }

  Future<void> uploadocument(
    String send,
    String recivers,
    String documenturl,
  ) async {
    try {
      String chatId = getChatId(send, recivers);

      await _firestore.collection('chatdata').doc(chatId).set({
        'lastMessage': "document",
        'sender': send,
        'receiver': chatId,
        'time': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await _firestore
          .collection('chatdata')
          .doc(chatId)
          .collection(chatId)
          .add({
            'type': 'document',
            'message': documenturl,
            'time': FieldValue.serverTimestamp(),
            'sender': send,
            'receiver': recivers,
          });
    } catch (e) {
      log("UPLOAD ERROR: $e");
    }
  }
}
