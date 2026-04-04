import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traychat/test.dart';

class Statuscontroller extends GetxController {
  final firestore = FirebaseFirestore.instance.collection('status');

  Stream<QuerySnapshot<Map<String, dynamic>>> getstatus() {
    return firestore.snapshots();
  }

  final picker = ImagePicker();
  Future<void> statusvideochose() async {
    try {
      final XFile? galleryVideo = await picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (galleryVideo == null) {
        return;
      }
      File file = File(galleryVideo.path);
      Get.to(() => statusvideo(file: file));
    } catch (e) {
      throw Exception(e);
    }
  }
}
